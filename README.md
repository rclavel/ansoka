# Install

- `rails generate model <model_name>`

- `rails db:migrate`

- Copy `test/utils/custom_test_utils.rb.example` to `test/utils/custom_test_utils.rb`

- In this file, set: `TESTED_CLASS_NAME='<model_name>'`

- And write your tests in the method `run_all_tests`.
  - `run_test(method_name)` method will call the method `method_name` in parameter. It will displays the amount of SQL queries done in the test.
  - `log_queries` method will display all the SQL queries done in the last test.
  - `@candidate_class` is the class of the candidate. You can instanciate it, or call a class method on it.
  - Don't forget to wrap your call to the candidate class with `test_wrapper`: it will check the amount of SQL queries.

- Optional: You can copy `test/factories.rb.example` to `test/factories.rb.example` and setup some factories to make the tests clear.

# Add a candidate

- `rails g ansoka candidate_name /path/to/candidate/git_folder`
- `rake test`
- And voilà!

```
$ rake test
Prepare candidates gems ...
Load gem CandidateName: 4 files loaded
Done!
Run options: --seed 26102

# Running:

[CandidateName][Start tests]
[CandidateName][TEST_01]
Queries: 14
[CandidateName][TEST_01][OK]
[CandidateName][QUERIES]
SELECT "users".* FROM "users" WHERE  ...
[CandidateName][QUERIES][END]
[CandidateName][TEST_02]
F

Failure:
MoulinetteTest#test_candidate_name [/Users/doctolib/dev/ansoka/test/utils/custom_test_utils.rb:68]:
--- expected
+++ actual
@@ -1 +1 @@
-:foo
+:bar



bin/rails test test/models/moulinette_test.rb:8



Finished in 0.136720s, 7.3142 runs/s, 95.0850 assertions/s.

1 runs, 13 assertions, 1 failures, 0 errors, 0 skips
```
