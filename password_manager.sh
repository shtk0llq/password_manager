echo "パスワードマネージャーへようこそ！"

if [ ! -e secret.key ]; then
  openssl rand -out secret.key 32
fi

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
      
      if [ -e encrypted.txt ]; then
        openssl enc -d -aes-256-cbc -pbkdf2 -in encrypted.txt -out passwords.txt -pass file:./secret.key
        echo "$service_name:$user_name:$password" >> passwords.txt
        openssl enc -e -aes-256-cbc -pbkdf2 -in passwords.txt -out encrypted.txt -pass file:./secret.key
      else
        echo "$service_name:$user_name:$password" >> passwords.txt
        openssl enc -e -aes-256-cbc -pbkdf2 -in passwords.txt -out encrypted.txt -pass file:./secret.key
      fi

      rm passwords.txt
      echo "パスワードの追加は成功しました。"
      ;;
    "Get Password")
      echo "サービス名を入力してください："
      read service_name
      openssl enc -d -aes-256-cbc -pbkdf2 -in encrypted.txt -out passwords.txt -pass file:./secret.key

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

      rm passwords.txt
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
