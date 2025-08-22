package e3;

import java.util.ArrayList;
import java.util.Objects;

public class Melody {

    ArrayList<Notes> Notas = new ArrayList<>();
    ArrayList<Accidentals> Acento = new ArrayList<>();
    ArrayList<Float> Duracion = new ArrayList<>();
    ArrayList<Notes> NotasEquiv = new ArrayList<>();
    ArrayList<Accidentals> AcentoEquiv = new ArrayList<>();

    public Melody () {}
    enum Notes {
        DO, RE, MI, FA, SOL, LA, SI
    }
    enum Accidentals{
        NATURAL, SHARP, FLAT
    }

    public void addNote(Notes note , Accidentals accidental , float time) {

        int longitud = Notes.values().length;
        int i;

        for(i = 0; i < longitud; i++){
            if(note == null || accidental == null || time <= 0){
                throw new IllegalArgumentException();
            }
        }
        Notas.add(note);
        Acento.add(accidental);
        Duracion.add(time);
    }

    public Notes getNote(int index) {

        if(index < Notas.size()){
            return Notas.get(index);
        }
        else{
            throw new IllegalArgumentException();
        }
    }

    public Accidentals getAccidental(int index) {

        if(index <= Accidentals.values().length){
            return Acento.get(index);
        }
        else{
            throw new IllegalArgumentException();
        }
    }

    public float getTime(int index) {

        if(index <= Notes.values().length){
            return Duracion.get(index);
        }
        else{
            throw new IllegalArgumentException();
        }

    }

    public int size() {

        return Notas.size();
    }

    public float getDuration () {

        float duracion = 0;
        for(float aux : Duracion){
            duracion += aux;
        }
        return duracion;
    }

    public void equivalencia(){

        int i;

        for(i=0; i<Notas.size(); i++){
            if(Notas.get(i)== Melody.Notes.RE && Acento.get(i)== Melody.Accidentals.FLAT){
                NotasEquiv.add(Notes.DO);
                AcentoEquiv.add(Accidentals.SHARP);
            }
            else if (Notas.get(i)== Melody.Notes.MI && Acento.get(i)== Melody.Accidentals.FLAT){
                NotasEquiv.add(Notes.RE);
                AcentoEquiv.add(Accidentals.SHARP);
            }
            else if(Notas.get(i)== Melody.Notes.FA && Acento.get(i)== Melody.Accidentals.FLAT) {
                NotasEquiv.add(Notes.MI);
                AcentoEquiv.add(Accidentals.NATURAL);
            }
            else if(Notas.get(i)== Melody.Notes.FA && Acento.get(i)== Melody.Accidentals.NATURAL) {
                NotasEquiv.add(Notes.MI);
                AcentoEquiv.add(Accidentals.SHARP);
            }
            else if(Notas.get(i)== Melody.Notes.SOL && Acento.get(i)== Melody.Accidentals.FLAT) {
                NotasEquiv.add(Notes.FA);
                AcentoEquiv.add(Accidentals.SHARP);
            }
            else if(Notas.get(i)== Melody.Notes.LA && Acento.get(i)== Melody.Accidentals.FLAT) {
                NotasEquiv.add(Notes.SOL);
                AcentoEquiv.add(Accidentals.SHARP);
            }
            else if(Notas.get(i)== Melody.Notes.SI && Acento.get(i)== Melody.Accidentals.FLAT) {
                NotasEquiv.add(Notes.LA);
                AcentoEquiv.add(Accidentals.SHARP);
            }
            else if(Notas.get(i)== Melody.Notes.DO && Acento.get(i)== Melody.Accidentals.FLAT) {
                NotasEquiv.add(Notes.SI);
                AcentoEquiv.add(Accidentals.NATURAL);
            }
            else if(Notas.get(i)== Melody.Notes.DO && Acento.get(i)== Melody.Accidentals.NATURAL) {
                NotasEquiv.add(Notes.SI);
                AcentoEquiv.add(Accidentals.SHARP);
            }
            else{
                NotasEquiv.add(Notas.get(i));
                AcentoEquiv.add(Acento.get(i));
            }
        }
    }

    @Override
    public boolean equals(Object o) {

        if(this == o) return true;
        if(!(o instanceof Melody)) return false;
        if(this.size() != ((Melody) o).size()) return false;

        this.equivalencia();
        ((Melody) o).equivalencia();

        if(!this.NotasEquiv.equals(((Melody) o).NotasEquiv)) return false;
        if(!this.AcentoEquiv.equals(((Melody) o).AcentoEquiv)) return false;
        return this.Duracion.equals(((Melody) o).Duracion); //Recomendacion Intellij, esto era un if y return false y siguiente linea return true
    }

    @Override
    public int hashCode () {
        return Objects.hash(this.NotasEquiv, this.AcentoEquiv, this.Duracion);
    }

    @Override
    public String toString () {
        StringBuilder cadena = new StringBuilder();
        int i;

        for(i = 0; i < Notas.size(); i++){
            cadena.append(Notas.get(i));
            if(Objects.equals(Acento.get(i), Accidentals.SHARP)){
                cadena.append("#");
            }
            else if(Objects.equals(Acento.get(i), Accidentals.FLAT)){
                cadena.append("b");
            }
            cadena.append("(").append(Duracion.get(i)).append(")");
            if(i < Notas.size() - 1){
                cadena.append(" ");
            }
        }
        return cadena.toString();
    }
}