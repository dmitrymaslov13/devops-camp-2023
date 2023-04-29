#!/bin/bash

# Constants
readonly WORKSPACE_DIR="./repos"
readonly KUSTOMIZATION_FILE_PATH="./${WORKSPACE_DIR}/kustomization.yaml"
readonly REPO_NAMES=( "$@" )
readonly VALID_REPO_REGEXP="^([0-9]|[a-z]|-|\.)*$"

########################################
# Clears the workspace folder
# Globals:
#   WORKSPACE_DIR
# Arguments:
#   None
# Returns:
#   None
########################################
clean_workspace() {
  rm -rf "./${WORKSPACE_DIR}" && mkdir "./${WORKSPACE_DIR}"
}

########################################
# Generate repo secret
# Globals:
#   None
# Arguments:
#   Configuration name
# Outputs:
#   Writes repo secret to stdout
########################################
generate_repo_secret() {
  local configuration_name="$1"
  cat <<EOF
  - name: $configuration_name
    namespace: argo-cd
    options:
      labels:
        argocd.argoproj.io/secret-type: repository
    literals:
      - name=$configuration_name
      - url=git@github.com:saritasa-nest/$configuration_name.git
      - type=git
      - project=default
    files:
      - sshPrivateKey=$configuration_name-deploy-key.pem
EOF
}

#################################################
# Generate kustomization file.
# Globals:
#   CONFIGURATION NAMES
#   KUSTOMIZATION_FILE_PATH
# Arguments:
#   None
# Outputs:
#   Writes to kustomization file generated config
#################################################
generate_kustomization_file() {
  cat <<EOF > "${KUSTOMIZATION_FILE_PATH}"
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
generatorOptions:
  disableNameSuffixHash: true
secretGenerator:
EOF

  for configuration_name in "${REPO_NAMES[@]}"; do

    if [[ ! "${configuration_name}" =~ $VALID_REPO_REGEXP ]]; then
      echo "Invalid name '${configuration_name}'" >&2
      continue
    fi

    ssh-keygen -t ed25519 -N '' -f "${WORKSPACE_DIR}/${configuration_name}-deploy-key.pem" > /dev/null
    generate_repo_secret "${configuration_name}" >> "${KUSTOMIZATION_FILE_PATH}"
  done
}

if [[ ${#REPO_NAMES[@]} -eq 0 ]]; then
  echo "No arguments passed. You need to pass at least 1 argument to proceed with the script."
  exit 0
fi

clean_workspace
generate_kustomization_file
kubectl kustomize "${WORKSPACE_DIR}"
