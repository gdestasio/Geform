class UserImporter < ActiveImporter::Base
  imports User

  column 'Codice fiscale', :taxcode
  column 'Email1', :email
  column 'Pec1', :pec
  column 'Sesso', :sex
  
  
  on :row_processing do
  	if row['Cognome'].present?
			model.last_name = row['Cognome'].strip.to_s.split.map(&:capitalize).join(' ')
		end

		if row['Nome'].present?
			model.first_name = row['Nome'].strip.to_s.split.map(&:capitalize).join(' ')
		end
    
    if row['Titolo'].present?
      if row['Titolo'] == "Avv."
        model.title = "Avv."
      end
      if row['Titolo'] == "Abogado"
        model.title = "Abogado"
      end
      if row['Titolo'] == "Avocado"
        model.title = "Avocado"
      end
      if row['Titolo'] == "Avv. Prof."
        model.title = "Avv. Prof."
      end
      if row['Titolo'] == "Dikigoros"
        model.title = "Dikigoros"
      end
    end
  	model.password = SecureRandom.hex(8).upcase
  end
end