class Student
  include Stone::Model
  
  attributes do
    string :first_name
    string :last_name
    integer :year
  end
  
  relationships do
    relate :teacher
    relate :essays
    relate :grades
  end
  
  validations do
    present :first_name, :last_name
    unique do
      first_name + " " + last_name
    end
  end
    
end