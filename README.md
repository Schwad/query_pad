# QueryPad

[![Build Status](https://travis-ci.com/Schwad/query_pad.svg?token=hzSwAUFrpt6kNMnH6gAx&branch=master)](https://travis-ci.com/Schwad/query_pad)

## Notes from the author

This is a private, internal application that allows users to post and answer questions. They may also search for relevant questions.

I approached this project very simply. I aimed to use the tools closest to my toolbox- straightforward REST/CRUD with Rails-based conventions and common tooling (devise, elasticsearch, postgres, bootstrap, heroku deployment, RSpec, Capybara).

For markdown processing, a `markdown_helper.rb` is implemented giving access to `markdown(text)` throughout the application. The rubygem [redcarpet](https://github.com/vmg/redcarpet) is utilised. HTML is properly escaped - even though this is an internal tool.

For searching, this application utilises the [pg_search gem](https://github.com/Casecommons/pg_search). This application applies this gem to use PostgreSQL' built-in [full text tsearch](https://www.postgresql.org/docs/current/static/textsearch-intro.html) as well as the enabled PostgreSQL [trigram extension](https://www.postgresql.org/docs/current/static/pgtrgm.html) to assist in 'fuzzy matching' search queries.

Its notable features are:

- New users may upvote (not downvote) questions or answers
- Users obtain a rolling 'score' that is simply the sum of upvotes on their questions and answers
- Users with a 'score' above 25 may downvote
- Users with a 'score' above 50 may 'delete' posts.
  * 'Deleted' posts are preserved in the database but hidden on the front end (using [acts_as_paranoid](https://github.com/rubysherpas/paranoia)).
  * Users lose five points for deleting a post and must supply a reason for deletion.
- CI build hooked up with [Travis-ci](https://travis-ci.com/Schwad/query_pad)
- Search maintained with elasticsearch using [searchkick](https://github.com/ankane/searchkick)

## Versions

- Ruby: 2.5.1
- Rails: 5.2.1

## Getting started

Run `bin/setup` to setup your development environment and install any needed dependencies.

## Tests

Run `rake`.

## Auth

Using Google Oauth with [omniauth-google-oauth2](https://github.com/zquestz/omniauth-google-oauth2) gem alongside [devise](https://github.com/plataformatec/devise).

## Secrets

Uses Rails credentials [introduced in 5.2](https://github.com/rails/rails/pull/30067).

## CI

- Rspec
- Brakeman
- Bundler Audit
