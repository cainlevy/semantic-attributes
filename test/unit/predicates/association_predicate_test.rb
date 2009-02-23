require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class AssociationPredicateTest < SemanticAttributes::TestCase
  def test_singular_associations
    predicate = Predicates::Association.new(:subscription)
    assert predicate.validate(users(:bob).subscription, users(:bob))
  end

  def test_plural_associations
    predicate = Predicates::Association.new(:subscriptions)
    assert predicate.validate(services(:free).subscriptions, services(:free))
  end

  def test_association_min
    predicate = Predicates::Association.new(:subscriptions)
    assert_equal 3, services(:free).subscriptions.size, "assuming three free subscriptions"

    predicate.min = 4
    predicate.max = nil
    assert !predicate.validate(services(:free).subscriptions, services(:free)), "min works"

    predicate.min = 3
    predicate.max = nil
    assert predicate.validate(services(:free).subscriptions, services(:free)), "min doesn't not work"
  end

  def test_association_max
    predicate = Predicates::Association.new(:subscriptions)
    assert_equal 3, services(:free).subscriptions.size, "assuming three free subscriptions"

    predicate.min = nil
    predicate.max = 2
    assert !predicate.validate(services(:free).subscriptions, services(:free)), "max works"

    predicate.min = nil
    predicate.max = 3
    assert predicate.validate(services(:free).subscriptions, services(:free)), "max doesn't not work"
  end

#   def test_recursion_for_new_records
#     # service has_many subscriptions
#     Service.stub_semantics_with(:subscriptions => :association)
#     # subscription belongs_to service
#     Subscription.stub_semantics_with(:service => :association)
#
#     unleaded = Service.new(:name => 'unleaded')
#     unleaded.subscriptions = [Subscription.new(:service => unleaded, :user => users(:bob))]
#
#     assert_nothing_raised {unleaded.valid?}
#   end
end