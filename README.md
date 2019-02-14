# Backup DB Procedures and Functions with Ruby

Usually database's functions and procedures are not version controlled. This ruby scrips provides a simple way to backup them in text files.


## Requirements

* [Ruby](https://www.ruby-lang.org/)
* [dbi](https://rubygems.org/gems/dbi/) : To connect database.

## How to use

1. Install dbi : 
`gem install dbi`
2. Edit `env.rb` file with your DB environment.
3. Run `ruby sp_backup.rb` to backup stored procedures, `ruby fn_backup.rb` to backup functions.

## Recommended usage

1. Add version control to backup directory.
2. Register a job schedule([Jenkins](https://jenkins.io/) etc). Running scripts and commit to version control.

## Limits

* Oracle only : Working on Oracle DBMS for now.
* 2 environments : PROD, DEV. Will make it more flexible if needed.