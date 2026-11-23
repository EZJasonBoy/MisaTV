cd /e/NEW/Kniephos
git add -A
git commit -q -F .cmsg.txt
rm -f .cmsg.txt
git log --oneline -2
ok=0
for i in $(seq 1 6); do
  if git -c http.proxy= -c https.proxy= push -f origin integrate30:refs/heads/verify30final >/dev/null 2>&1; then echo PUSHED; ok=1; break; fi
  sleep 10
done
echo ok=$ok
gh workflow run build-android.yml --repo yagami-hue/MisaTV --ref verify30final 2>&1 | head -1
sleep 15
gh run list --repo yagami-hue/MisaTV --workflow=build-android.yml --limit 1 --json databaseId,headSha,status --jq '.[] | "id=" + (.databaseId|tostring) + " sha=" + .headSha[0:7] + " " + .status' 2>&1