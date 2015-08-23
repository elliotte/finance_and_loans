FactoryGirl.define do
  factory :note do
    body "This is a note"
    commenter "MyString"
    type "Note"
  end

  factory :recNote, parent: :note do
  	body "This is a rec note"
    type "Reconciliation"
  end

  factory :subNote, parent: :note do
  	body "This is a rec note"
    type "Substantiation"
  end

end
