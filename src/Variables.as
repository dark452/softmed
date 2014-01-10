package
{
	import flash.data.SQLConnection;
	
	import mx.collections.ArrayCollection;
	import mx.controls.DataGrid;
	import mx.controls.DateField;
	import mx.controls.NumericStepper;

	
	import mx.controls.ComboBox;
	import mx.controls.Label;
	import mx.controls.TextInput;
	
	
	[Bindable]
	public class Variables
	{
		
		private   static var variables:Variables;
		
		public   static function getInstance():Variables
		{
			if (variables == null)
			{
				variables = new Variables();
			}
			return variables;
		}
		
		
		public var datosDB      :ArrayCollection;
		public var tamanoBD		:String;
		public var id			:String;
		public var conn         :SQLConnection;
		public var listaPacientes:DataGrid;
		public var rut         :String;
		public var nombres         :String;
		public var apellidoPaterno         :String;      
		public var apellidoMaterno         :String;    
		public var sexo         :String;
		public var fechaNacimiento           :String;
		public var prevision            :String;
		public var dv            :String;
		
		public var campoDv	:TextInput;
		public var campoRut      :TextInput;
		public var campoNombres      :TextInput;
		public var campoApellidoPaterno   :TextInput;
		public var campoApellidoMaterno   :TextInput;
		public var campoSexo      :ComboBox;
		public var campoFechaNacimiento      :DateField;
		public var campoPrevision      :ComboBox;
		public var labelId			:Label;
		public var labelTamanoBD	:Label;
		
		
	}
}