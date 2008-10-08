class Class #:nodoc:
  def alias_accessor(new, old)
    alias_reader(new, old)
    alias_writer(new, old)
  end
  
  def alias_reader(new, old)
    alias_method new, old
  end
  
  def alias_writer(new, old)
    alias_method "#{new}=", "#{old}="
  end
end
