require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class UniquePredicateTest < SemanticAttributes::TestCase
  def setup
    User.stub_semantics_with(:login => :unique)
    @predicate = User.semantic_attributes[:login].get(:unique)

    @fred = User.new(:first_name => 'fred', :last_name => 'flat')
  end

  def test_defaults
    assert_equal false, @predicate.case_sensitive, 'case insensitive by default'
    assert_equal [], @predicate.scope, 'default scope is empty array'
  end

  def test_uniqueness_validation_scoping
    assert !@predicate.validate(users(:bob).login, @fred)
    @predicate.scope = :last_name
    assert @predicate.validate(users(:bob).login, @fred), "when scoped, it becomes valid"
  end

  def test_case_sensitive_uniqueness_validation
    @predicate.case_sensitive = true

    assert !@predicate.validate(users(:bob).login, @fred), "case match means not unique"
    assert @predicate.validate(users(:bob).login.upcase, @fred), "case mismatch means unique"
  end

  def test_case_insensitive_uniqueness_validation
    @predicate.case_sensitive = false

    assert !@predicate.validate(users(:bob).login, @fred), "case match means not unique"
    assert !@predicate.validate(users(:bob).login.upcase, @fred), "case mismatch is still not unique"
  end

  def test_uniqueness_validation_excludes_self
    @fred.update_attribute(:login, 'fred')

    assert @predicate.validate(@fred.login, @fred), "still valid after being saved"
    assert !@predicate.validate(users(:bob).login, @fred), "but still not valid when duplicating a *different* record"
  end

  def test_uniqueness_of_numbers
    Subscription.stub_semantics_with(:user_id => :unique)

    bobs_second_subscription = Subscription.new(:user => users(:bob), :service => services(:premium))
    assert !bobs_second_subscription.valid?
    assert bobs_second_subscription.errors[:user_id]
  end

  def test_case_insensitive_is_non_destructive
    @predicate.case_sensitive = false
    @fred.update_attribute(:login, "Fred")

    @predicate.validate(@fred.login, @fred)
    assert_equal "Fred", @fred.login, "attribute value was not changed by validate()"
  end
end
