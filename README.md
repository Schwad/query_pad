# QueryPad

[![Build Status](https://travis-ci.com/Schwad/query_pad.svg?token=hzSwAUFrpt6kNMnH6gAx&branch=master)](https://travis-ci.com/Schwad/query_pad)

## Notes from the author

This is a private, internal application that allows users to post and answer questions. They may also search for relevant questions. Its notable features are:

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
