class Teacher
  include Stone::Model
  
  attributes do
    string :first_name
    string :last_name
    string :email
  end
  
  relationships do
    relate :student
    relate :essays
    relate :grades
  end
  
  validations do
    present :first_name, :last_name, :email
    formatted :email, /blah@blah.com/
  end
  
end