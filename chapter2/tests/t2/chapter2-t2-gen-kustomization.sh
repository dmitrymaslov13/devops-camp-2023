if [[ $# -eq 0 ]]; then
  echo this script requires 1 or more arguments
  echo argument - configuration name
  exit 0
fi

folder=repos
outputFilePath=${folder}/kustomization.yaml

# Clean workspace
clean_workspace() {
  rm -rf ${folder} && mkdir ${folder}
}

# Get secret generator.
# arg1 Repo name.
# return secretGenerator with name.
get_secret_generator() {
local repo_name=$1
cat <<EOF
  - name: $repo_name
    namespace: argo-cd
    options:
      labels:
        argocd.argoproj.io/secret-type: repository
    literals:
      - name=$repo_name
      - url=git@github.com:saritasa-nest/$repo_name.git
      - type=git
      - project=default
    files:
      - sshPrivateKey=$repo_name-deploy-key.pem
EOF
}

clean_workspace

# Write write non-reusable configuration to header for kustomization file.
cat <<EOF > ${outputFilePath}
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
generatorOptions:
  disableNameSuffixHash: true
secretGenerator:
EOF

for name in $*; do
  ssh-keygen -t ed25519 -N '' -f ${folder}/$name-deploy-key.pem > /dev/null
  get_secret_generator $name >> ${outputFilePath}
done

kubectl kustomize ${folder}