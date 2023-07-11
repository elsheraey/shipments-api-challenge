# shipment-api-test

**shipment-api-test** is a backend focused interview project.

Given a database with already seeded tables and data, please create an API web application server that responds to a URL and returns json. More specifically, your web server will respond to the `GET index` endpoint `/api/v1/shipments` and return data according to the specification as described in `api/v1/shipments_xxx_spec.rb`

The Shipup backend is written in Ruby on Rails, and while its influence is obvious, this project is designed to be language and framework agnostic. Your web server can be written in Python with Django/Flask, Javascript with Node+Express, or something more exotic. The tests are written in rspec+Ruby, but should be very readable even if you don't know any Ruby: All they do is ping a URL and inspect the json response.

## Instructions

1. Read the rest of this README and review `api/v1/shipments_xxx_spec.rb` files to understand the endpoint requirements.
2. Two options here:
   - RUBY VERSION
     If ruby is installed on your machine (`ruby -v`), the only dependency is rspec (and bundler)
     2. Install project dependencies: run `bundle install` at the root of this project
     3. run the whole test suite: `bundle exec rspec`. All test should fail for now
   - ALTERNATE DOCKER VERSION
     If ruby is not installed on your machine, we provide a dockerized version of the specs for convenience
     2. Install and launch [docker desktop](https://www.docker.com/products/docker-desktop).
     3. Update the BASE_URL env variable in `spec/spec_helper.rb` to point to your host machine from docker
     4. If you wish to run the tests, you can run `docker-compose run spec bundle exec rspec`.
3. You can now develop the server that will make the tests successfully pass.

## DB connection information

You can connect to the **PostgreSQL** database with already seeded tables and data using
those credentials:

- host: shipup-glexport.cfu73h8ke9p3.eu-west-1.rds.amazonaws.com
- port: 5432
- database: shipup_test_db
- username: readonly_user
- password: readonly

## The rspec test

The rspec test pings `GET /api/v1/shipments` with various parameters and examines the json response.
We've split the specs in 4 different files so you can take an iterative approach to solving this test.
We encourage you to send one commit per spec file

You can run a specific spec file by running `bundle exec rspec spec/api/v1/shipments_xxx_spec.rb` instead
of simply running `bundle exec rspec`

## The Database and Schema

The sample database provided consists of four tables:

- companies
- shipments
- products
- shipment_products

A company has no association columns.
Both shipments and products have a `company_id` (belong to a company).
The shipment_products table is a join table that connects shipments and products, and thus has both a `product_id` and `company_id`.

```
shipup_test=# \d+ companies
Table "public.companies"
   Column   |            Type
------------+-----------------------------
 id         | integer
 name       | character varying
 created_at | timestamp without time zone
 updated_at | timestamp without time zone

shipup_test=# \d+ shipments
Table "public.shipments"
              Column               |            Type
-----------------------------------+-----------------------------
 id                                | integer
 name                              | character varying
 company_id                        | integer
 international_transportation_mode | character varying
 international_departure_date      | date
 created_at                        | timestamp without time zone
 updated_at                        | timestamp without time zone

shipup_test=# \d+ products
Table "public.products"
   Column    |            Type
-------------+-----------------------------
 id          | integer
 sku         | character varying
 description | character varying
 company_id  | integer
 created_at  | timestamp without time zone
 updated_at  | timestamp without time zone

shipup_test=# \d+ shipment_products
Table "public.shipment_products"
   Column    |            Type
-------------+-----------------------------
 id          | integer
 product_id  | integer
 shipment_id | integer
 quantity    | integer
 created_at  | timestamp without time zone
 updated_at  | timestamp without time zone
```
