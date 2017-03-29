# Install

- `rails generate model <model_name>`
- `rails db:migrate`
- Copy `test/utils/custom_test_utils.rb.example` to `test/utils/custom_test_utils.rb`
- In this file, set: `TESTED_CLASS_NAME='<model_name>'`
- And write your tests in the method `run_all_tests`.
-- `run_test(method_name)` method will call the method `method_name` in parameter. It will displays the amount of SQL queries done in the test.
-- `log_queries` method will display all the SQL queries done in the last test.
-- `@candidate_class` is the class of the candidate. You can instanciate it, or call a class method on it.
-- Don't forget to wrap your call to the candidate class with `test_wrapper`: it will check the amount of SQL queries.
- Optional: You can copy `test/factories.rb.example` to `test/factories.rb.example` and setup some factories to make the tests clear.
