#!/bin/bash

lang_button_style=".lang-button{
  position: fixed;
  right: 30px;
  top: 30px;
  width: 78px;
  height: 26px;
  line-height: 26px;
  text-align: center;
  border: 1px solid #383F66;
  color: #007EFF;
  text-decoration: none;
  border-radius: 3px;
  transition: all 300ms;
  cursor: pointer;
  background: none;
  z-index: 31;
}
.lang-button:hover{
  border-color: #00a7b3;
}"

lang_button_en="      <a class=\"lang-button\" href=\"/apidoc/cn\">简体中文</a>"
lang_button_cn="      <a class=\"lang-button\" href=\"/apidoc\">English</a>"

# todo 明天继续
# param 文件名
add_lang_button() {
    local filename=$1
    local var1=$lang_button_cn
    add_lang_button_style filename
    # 如果是中文文档，则添加跳转到英文的按钮
    if [[ "${filename:0:2}" = "cn" ]];
      then
        add_lang_button_element filename var1
      else
        # 如果是英文文档，则添加跳转到中文的按钮
        add_lang_button_element filename lang_button_en
    fi
    return 0
}

# param1 文件名
# param2 按钮元素
add_lang_button_element() {
  # 由于不会在倒数第几行前插入的命令，这里曲线救国
  # 先删除最后3行
  for (( i = 0; i < 3; i++ )); do
      sed -i '$d' "$1"
  done
  # 在倒数最后一行前插入 按钮元素
  sed -i "\$i $2" "$1"
  # 前面删除的3行，再加回来
  sed -i "\$a </body>" "$1"
  sed -i "\$a </html>" "$1"
}

# param 文件名
add_lang_button_style() {
  sed "201a $lang_button_style" "$1"
}

## 确保当前在main分支下

# 1. 在 /source 内的文件作出修改后，编译出html
# docker run --rm --name slate -v $(pwd)/build:/srv/slate/build -v $(pwd)/source:/srv/slate/source slatedocs/slate build

# 2. 将 /build 内生成的html文件中 插入语言切换按钮
html_files=$(ls ./build | grep .html)
for file in $html_files ; do
    add_lang_button "$file"
done
