class CreateCriteria < ActiveRecord::Migration
  def change
    create_table :criteria do |t|
    	t.text :name
    	t.float :importance, default: 0
    	t.integer :operator
      t.timestamps null: false
    end

    Criterium.create(name: 'Coerenza dei temi trattati con le finalità del Reg. CNF e attinenza professionale sotto profili tecnici, scientifici, culturali e interdisciplinari', importance: 0.1, operator: 0)
    Criterium.create(name: 'Tipologia (livello base, avanzato, specialistico)', importance: 0.1, operator: 0)
    Criterium.create(name: 'Tipologia e qualità dei supporti di ausilio all\'esposizione (proiezione di filmati, diapositive e distribuzione anticipata di materiale di studio)', importance: 0.1, operator: 0)
    Criterium.create(name: 'Metodologia didattica adottata (es. simulazione, tavola rotonda) e partecipazione interattiva (eventuale spazio dedicato alle domandei)', importance: 0.1, operator: 0)
    Criterium.create(name: 'Esperienze e competenze specifiche dei relatori in relazione alla natura dell\'evento', importance: 0.1, operator: 0)
    Criterium.create(name: 'Elaborazione e distribuzione di un questionario di valutazione finale dell\'evento da parte dei partecipanti', importance: 0.1, operator: 0)
    Criterium.create(name: 'Metodi di controllo della continua ed effettiva partecipazione, come verifiche intermedie e verifica finale', importance: 0.1, operator: 0)
  end
end
