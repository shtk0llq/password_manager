echo "パスワードマネージャーへようこそ！"

while [ "$input" != "Exit" ]
do
  echo "次の選択肢から入力してください(Add Password/Get Password/Exit)："
  read input

  case "$input" in
    "Add Password")
      echo "サービス名を入力してください："
      read service_name

      echo "ユーザー名を入力してください："
      read user_name

      echo "パスワードを入力してください："
      read password
      
      echo "$service_name:$user_name:$password" >> passwords.txt

      echo "パスワードの追加は成功しました。"
      ;;
    "Get Password")
      echo "サービス名を入力してください："
      read service_name
      grep -q "^$service_name:" passwords.txt

      if [ $? -eq 0 ]; then
        service=$(grep "^$service_name:" passwords.txt)
        IFS=":"
        read service_name user_name password <<< "$service"

        echo "サービス名：$service_name"
        echo "ユーザー名：$user_name"
        echo "パスワード：$password"
      else
        echo "そのサービスは登録されていません"
      fi
      ;;
    "Exit")
      echo "Thank you!"
      ;;
    *)
      echo "入力が間違えています。Add Password/Get Password/Exit から入力してください。"
      ;;
  esac
done

exit 0
