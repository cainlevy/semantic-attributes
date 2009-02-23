require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class ValidationsTest < SemanticAttributes::TestCase
  def setup
    User.stub_semantics_with(:login => :required)
    @record = User.new
    @login_required = @record.semantic_attributes['login'].get('required')
  end

  def test_validation_hook
    @record.expects(:validate_predicates)
    @record.valid?
  end

  def test_validation_errors
    assert !@record.valid?
    assert @record.errors.on(:login)
    assert_equal 'is required.', @record.errors[:login]
  end

  def test_that_errors_are_localized
    @record.expects(:_).returns("translated!")
    @record.valid?
    assert_equal "translated!", @record.errors[:login]
  end

  def test_validate_on_default
    assert_equal :both, @record.semantic_attributes['login'].get('required').validate_on
  end

  ##
  ## attr_valid?
  ##

  def test_attribute_valid?
    assert !@record.login_valid?
    @record.login = "foo"
    assert @record.login_valid?
  end

  def test_attribute_valid_with_conditional_validation
    assert !@record.login_valid?
    @record.stubs(:validate_predicate?).returns(false)
    assert @record.login_valid?
  end

  ##
  ## validate_predicate?
  ##

  def test_validate_predicate_with_validate_if_symbol
    @record.stubs(:no).returns(false)
    @record.stubs(:yes).returns(true)

    assert @record.send(:validate_predicate?, @login_required)

    @record.semantic_attributes['login'].get('required').validate_if = :no
    assert !@record.send(:validate_predicate?, @login_required)

    @record.semantic_attributes['login'].get('required').validate_if = :yes
    assert @record.send(:validate_predicate?, @login_required)
  end

  def test_validate_predicate_with_validate_if_proc
    assert @record.send(:validate_predicate?, @login_required)

    @record.semantic_attributes['login'].get('required').validate_if = proc {false}
    assert !@record.send(:validate_predicate?, @login_required)

    @record.semantic_attributes['login'].get('required').validate_if = proc {true}
    assert @record.send(:validate_predicate?, @login_required)
  end

  def test_validate_predicate_with_validate_on_create
    @record = users(:george)
    @record.login = nil

    # test assumptions
    assert !@record.new_record?
    assert @record.send(:validate_predicate?, @login_required)

    # the test
    @record.semantic_attributes['login'].get('required').validate_on = :create
    assert !@record.send(:validate_predicate?, @login_required)
  end

  def test_validate_predicate_with_validate_on_update
    # test assumptions
    assert @record.new_record?
    assert @record.send(:validate_predicate?, @login_required)

    # the test
    @record.semantic_attributes['login'].get('required').validate_on = :update
    assert !@record.send(:validate_predicate?, @login_required)
  end

  ##
  ## :or_empty
  ##

  def test_allow_empty
    User.stub_semantics_with(:login => {:number => {:or_empty => true}})

    # empty values should skip the validate method
    predicate = @record.semantic_attributes['login'].get('number')
    predicate.expects(:validate).never

    [nil, '', []].each do |empty_value|
      @record.login = empty_value
      assert @record.valid?
    end
  end

  def test_disallow_empty
    User.stub_semantics_with(:login => {:number => {:or_empty => false}})

    # empty values should skip the validate method
    predicate = @record.semantic_attributes['login'].get('number')
    predicate.expects(:validate).never

    [nil, '', []].each do |empty_value|
      @record.login = empty_value
      assert !@record.valid?
      assert @record.errors.on(:login)
    end
  end
end