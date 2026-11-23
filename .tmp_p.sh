cd /e/NEW/Kniephos
python .tmp_x.py; rm -f .tmp_x.py
grep -n -B1 -A1 'desugar_jdk_libs' android/app/build.gradle.kts
git add -A && git commit -q -m "fix(android): 脱糖改用 desugar_jdk_libs_nio 2.1.5（hook-release.aar 的 AAR 元数据要求）"
git log --oneline -1
for i in $(seq 1 6); do
  if git -c http.proxy= -c https.proxy= push -f origin integrate30:refs/heads/verify30final >/dev/null 2>&1; then echo PUSHED; break; fi
  sleep 10
done
gh workflow run build-android.yml --repo yagami-hue/MisaTV --ref verify30final 2>&1 | head -1
sleep 15
gh run list --repo yagami-hue/MisaTV --workflow=build-android.yml --limit 1 --json databaseId,headSha,status --jq '.[] | "id=" + (.databaseId|tostring) + " sha=" + .headSha[0:7] + " " + .status' 2>&1