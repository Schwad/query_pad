# QueryPad

[![Build Status](https://travis-ci.com/Schwad/query_pad.svg?token=hzSwAUFrpt6kNMnH6gAx&branch=master)](https://travis-ci.com/Schwad/query_pad)
[![Maintainability](https://api.codeclimate.com/v1/badges/d4197eda5b2dc402411d/maintainability)](https://codeclimate.com/github/Schwad/query_pad/maintainability)
[![Coverage Status](https://coveralls.io/repos/github/Schwad/query_pad/badge.svg)](https://coveralls.io/github/Schwad/query_pad)

## Notes from the author

This is a private, internal application that allows users to post and answer questions. They may also search questions.

### Approach

I went through this project very simply. I aimed to use the tools closest to my toolbox- straightforward REST/CRUD with Rails-based conventions and common technologies (`devise`, `postgres`, `bootstrap`, `heroku` deployment, `RSpec`, `Capybara`).

### Feature/Code notes

For markdown processing, `markdown_helper.rb` gives access to `markdown(text)` throughout the application. This is done with [redcarpet](https://github.com/vmg/redcarpet).

For searching, QueryPad utilises the [pg_search gem](https://github.com/Casecommons/pg_search). It applies this gem to use PostgreSQL' built-in [full text tsearch](https://www.postgresql.org/docs/current/static/textsearch-intro.html) as well as the enabled PostgreSQL [trigram extension](https://www.postgresql.org/docs/current/static/pgtrgm.html) to assist in 'fuzzy matching' search queries.

I used the [decorator pattern](https://github.com/drapergem/draper) within the application for [user flair](app/decorators/user_decorator.rb).

There is a user voting feature employing polymorphic associations with `Vote` to `Question` and `Answer` (associating to `votable`). Upvote vs. downvote is set on a type attribute on `vote`.

Other notable features:

- Users obtain a rolling 'score' that is simply the sum of upvotes on their questions and answers. This is set with `increment` counter cache directly to the database. Removing a vote or adding a downvote decrements scores on users, questions and answers.
- Users with a 'score' above 25 may downvote and become a 'power user' with flair.
- Users with a 'score' above 50 may 'delete' posts and become a 'moderator', also with flair.
- 'Deleted' posts are preserved in the database but hidden on the front end (using [acts_as_paranoid](https://github.com/rubysherpas/paranoia)).
- You can sort questions on index by recently created or highest score.
- CI build hooked up with [Travis-ci](https://travis-ci.com/Schwad/query_pad)

### Constraints

I built this application expecting a relatively small database (< 10k Q's+A's), and a commensurate request volume. I also limited myself to a seven-day build-cycle, working in evenings where permissible. This allowed me to fulfill the specifications and add a handful of extended features. I held myself to the standard that the application must pass a traditional CI build (RSpec/brakeman/bundler-audit) and have >95% test coverage.

This application observes the [YAGNI](https://ronjeffries.com/xprog/articles/practices/pracnotneed/) and [KISS](http://people.apache.org/~fhanik/kiss.html) principles. If QueryPad were to scale much larger than a normal internal tool, I would look to use [searchkick](https://github.com/ankane/searchkick) for elasticsearch implementation. I could see upvote/downvote logic being a pinchpoint at large scales. That could be resolved using read/write to a [redis store](https://github.com/redis/redis-rb). Anything beyond the simple current authorities of 'power user' and 'moderator' would benefit from a [CanCanCan](https://github.com/CanCanCommunity/cancancan) or [Pundit](https://github.com/varvet/pundit) authorisation library.

## Versions

- Ruby: 2.5.1
- Rails: 5.2.0

## Run the application in development

Run `bin/setup` to setup your development environment and install any needed dependencies.

## Tests

Run `rake`.

## Auth

Using Google Oauth with the [omniauth-google-oauth2](https://github.com/zquestz/omniauth-google-oauth2) gem alongside [devise](https://github.com/plataformatec/devise).

## Secrets

Uses Rails credentials [introduced in 5.2](https://github.com/rails/rails/pull/30067).

## CI

- Rspec
- Brakeman
- Bundler Audit
