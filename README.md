# QueryPad

[![Build Status](https://travis-ci.com/Schwad/query_pad.svg?token=hzSwAUFrpt6kNMnH6gAx&branch=master)](https://travis-ci.com/Schwad/query_pad)
[![Maintainability](https://api.codeclimate.com/v1/badges/d4197eda5b2dc402411d/maintainability)](https://codeclimate.com/github/Schwad/query_pad/maintainability)

## Notes from the author

This is a private, internal application that allows users to post and answer questions. They may also search questions.

I approached this project very simply. I aimed to use the tools closest to my toolbox- straightforward REST/CRUD with Rails-based conventions and common tooling (devise, elasticsearch, postgres, bootstrap, heroku deployment, RSpec, Capybara).

For markdown processing, `markdown_helper.rb` gives access to `markdown(text)` throughout the application. This is done with [redcarpet](https://github.com/vmg/redcarpet). HTML is properly escaped - even though this is an internal tool.

For searching, this application utilises the [pg_search gem](https://github.com/Casecommons/pg_search). This application applies this gem to use PostgreSQL' built-in [full text tsearch](https://www.postgresql.org/docs/current/static/textsearch-intro.html) as well as the enabled PostgreSQL [trigram extension](https://www.postgresql.org/docs/current/static/pgtrgm.html) to assist in 'fuzzy matching' search queries.

One special mention was the [decorator pattern](https://github.com/drapergem/draper) initialised at particular points within the application (such as [user flair](app/decorators/user_decorator.rb)).

This application observes the [YAGNI](https://ronjeffries.com/xprog/articles/practices/pracnotneed/) and [KISS](http://people.apache.org/~fhanik/kiss.html) principles. If this application were to scale much larger than a normal internal tool, I would look to use [searchkick](https://github.com/ankane/searchkick) for elasticsearch implementation. I could see upvote/downvote logic being a pinchpoint at large scales that could be resolved using read/write to a [redis store](https://github.com/redis/redis-rb). Anything beyond the simple current authorities of 'power user' and 'moderator' would benefit from a [CanCanCan](https://github.com/CanCanCommunity/cancancan) or [Pundit](https://github.com/varvet/pundit) authorisation library.

The user voting feature uses a polymorphic association between `Vote` with `Question` and `Answer` associating to `votable`. Upvote vs. downvote is set on a type attribute on `vote`.

Its notable features are:

- New users may upvote (not downvote) questions or answers
- Users obtain a rolling 'score' that is simply the sum of upvotes on their questions and answers
- Users with a 'score' above 25 may downvote
- Users with a 'score' above 50 may 'delete' posts.
  * 'Deleted' posts are preserved in the database but hidden on the front end (using [acts_as_paranoid](https://github.com/rubysherpas/paranoia)).
  * Users lose five points for deleting a post and must supply a reason for deletion.
- You can sort question index by recent or most popular.
- CI build hooked up with [Travis-ci](https://travis-ci.com/Schwad/query_pad)

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
