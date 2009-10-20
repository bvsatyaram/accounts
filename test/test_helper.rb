ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

class ActiveSupport::TestCase
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  #
  # The only drawback to using transactional fixtures is when you actually 
  # need to test transactions.  Since your test is bracketed by a transaction,
  # any transactions started in your code will be automatically rolled back.
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures  = false

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  # Asserts that an error is raised on the given field and with the given
  # message (optional) by the given block
  def assert_raise_error_on_field(exception_class,field,expected_message = nil,options = {},&block)
    error_raised = nil
    error_info = assert_raise exception_class, "Did not get exception for field #{field}" do
      # Execute the block in a rescue block so that we can re-raise the exception
      # if required.
      begin
        yield
      rescue => error_raised
        raise error_raised
      end
    end

    # Extract the field name and error message from the return value
    # Eg., Process "Validation failed: Coach can't be blank, Area is not given"
    # to get ['coach', 'can't be blank'], ['area', 'is not given'] pairs.
    #
    error_info.message.match(/.*: (.*)/)

    # Panic if no field errors.
    assert_not_nil $1

    field_errors = $1.split(", ")

    match_found = false
    wrong_message = false

    field_errors.each do |error_entry|
      # Skip to next error if not matched.
      next unless error_entry.match(/(#{field.to_s.humanize}) (.*)/)

      if field.to_s.humanize.downcase == $1.downcase
        # First condition matched
        match_found = true

        # See if second condition also matches, if given
        if !expected_message.blank? && expected_message != $2
          match_found = false
          wrong_message = $2
        end
      end
    end

    if !match_found
      if wrong_message
        assert false, "Exception message on field #{field} did not match: " +
          "Expected '#{expected_message}', Got '#{wrong_message}'"
      else
        assert false, "Expected to raise exception on field #{field}, but nothing raised"
      end
    end

    raise error_raised if options[:cascade]
  end
end
