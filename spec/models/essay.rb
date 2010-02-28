class Essay
  include Stone::Model
  
  attributes do
    string :title
    string :body
    timestamps
  end
  
  relationships do
    relate :teacher
    relate :student
    relate :grade
    
    depends_on :student
  end
  
  validations do
    present :title
    present :body
    length :title, 2..50      
  end
  
end