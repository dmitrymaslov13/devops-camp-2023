if [[ $# -eq 0 ]]; then
   echo args passed
   exit 0
fi

folder=repos
outputFilePath=${folder}/kustomization.yaml

if [[ -d ${folder} ]]; then
  rm -rf ${folder} &> /dev/null
fi

mkdir -p ${folder}

cat <<EOF > ${outputFilePath}
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

generatorOptions:
  disableNameSuffixHash: true

secretGenerator:
EOF

# arg1 Name
# return secretGenerator with name
function getSecretGenerator {
cat <<EOF
  - name: $1
    namespace: argo-cd
    options:
      labels:
        argocd.argoproj.io/secret-type: repository
    literals:
      - name=$1
      - url=git@github.com:saritasa-nest/$1.git
      - type=git
      - project=default
    files:
      - sshPrivateKey=$1-deploy-key.pem

EOF
}

for name in $*; do
  ssh-keygen -t ed25519 -N '' -f ${folder}/$name-deploy-key.pem > /dev/null
  getSecretGenerator $name >> ${outputFilePath}
done

kubectl kustomize ${folder}