class Grade
  include Stone::Model
  
  attributes do
    string :grade
    integer :score
  end
  
  relationships do
    relate :teacher
    relate :student
    relate :essay
    
    depends_on :essay
  end
  
  validations do
    present :score
    length :grade, 1..2
  end
  
  callbacks do
    on_post :assign_grade, :notify_student
    on_put :assign_grade, :notify_student_of_change
  end
  
  def assign_grade
  end
  
  def notify_student
  end
  
  def notify_student_of_change
  end
  
end