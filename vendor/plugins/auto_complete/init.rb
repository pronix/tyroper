ActionController::Base.send :include, AutoComplete
ActionController::Base.helper AutoCompleteMacrosHelper
ActionView::Base.send :include, AutoCompleteFormHelper
