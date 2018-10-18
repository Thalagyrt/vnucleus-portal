require 'simplecov'
SimpleCov.start 'rails' do
  add_group 'Cells', 'app/cells'
  add_group 'Validators', 'app/validators'

  add_filter '/lib/'
  add_filter '/app/decorators/'
end