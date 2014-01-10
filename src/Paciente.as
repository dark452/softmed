package 
{
	public class Paciente
	{
		public var _id:String; // de paciente
		public var _rut:String; // de paciente
		public var _nombres:String; // de paciente
		public var _apellido_paterno:String; // de paciente
		public var _apellido_materno:String; // de paciente
		public var _fecha_nacimiento:String; // de paciente
		public var _genero:String; // de paciente
		public var _prevencion:String; // de paciente
				
		public function Paciente(i:String,r:String,n:String,ap:String,am:String,fn:String,g:String,p:String)
		{
			_id=i;
			_rut=r;
			_nombres=n;
			_apellido_paterno=ap;
			_apellido_materno=am;
			_fecha_nacimiento=fn;
			_genero=g;
			_prevencion=p;
		}
	}
}