set -e

curl -fsSL https://fnm.vercel.app/install | bash

head -n -4 ~/.zshrc > tmp_file && cat tmp_file > ~/.zshrc && rm tmp_file
