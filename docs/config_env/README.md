# [Git使用技巧](https://learngitbranching.js.org/?locale=zh_CN)

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

## git merge和git rebase

```bash
#所在分支为master，带合并分支为devlop
git merge devlop

#所在分支为devlop，带变基分支为master
git rebase master
```

## Git 同步上游分支代码

```bash
#设置git同步快捷命令
alias.sync=!sh -c "git pull && git fetch upstream && git checkout master && git merge upstream/master && git push origin master"

#执行同步命令
git sync
```
