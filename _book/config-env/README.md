# Git使用技巧

## 为每个项目单独设置用户名和邮箱

```bash
git config --local user.name xxx
git config --local user.email xxx

# 查询
git config --local -l
```

## git删除全部提交历史，成为一个新的仓库

```bash
#创建一个新的分支
git checkout --orphan latest_branch

#添加所有文件
git add -A

#提交更改
git commit -am "commit"

#删除需要替换的分支
git branch -D master

#重命名创建的分支为删除的分支
git branch -m master

#强制提交到远程仓库
git push -f origin master
```
