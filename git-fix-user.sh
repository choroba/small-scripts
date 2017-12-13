#!/bin/bash
name=$(git config user.name)
email=$(git config user.email)

git filter-branch --commit-filter "
        if [ \"\$GIT_COMMITTER_NAME\" = '$name' ];
        then
                GIT_AUTHOR_NAME='$name';
                GIT_COMMITTER_EMAIL='$email';
                GIT_AUTHOR_EMAIL='$email';
                git commit-tree \"\$@\";
        else
                git commit-tree \"\$@\";
        fi" HEAD
