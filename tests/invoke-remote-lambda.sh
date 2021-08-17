
function_name="ARTTECH-Iris"
p=default
k=simple
while getopts ":p:k:" o; do
    case "${o}" in
      p) p=${OPTARG} ;;
      k) k=${OPTARG} ;;
      *) usage ;;
    esac
done
shift $((OPTIND-1))

aws lambda invoke \
  --function-name "${function_name}" \
  --profile "${p}" \
  --payload file://tests/payloads/"${k:-simple}"_input.json \
  response.json

cat response.json && rm response.json
