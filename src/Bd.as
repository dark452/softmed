package
{
	

	public class Bd
	{
		
		//////////// BASE DE DATOS
		import air.net.URLMonitor;
		
		import com.adobe.air.crypto.EncryptionKeyGenerator;
		import com.maclema.mysql.events.MySqlErrorEvent;
		import com.maclema.util.ResultsUtil;
		
		import flash.data.*;
		import flash.data.SQLConnection;
		import flash.data.SQLStatement;
		import flash.errors.*;
		import flash.events.*;
		import flash.filesystem.File;
		import flash.utils.*;
		
		import mx.collections.ArrayCollection;
		import mx.controls.Alert;
		import mx.events.FlexEvent;
		
		
		
		private function handleError(e:MySqlErrorEvent):void {
			Alert.show(e.text);
		}
		
		private const dbFileName:String = "encryptedDatabase.db";
		private var dbFile:File;
		private var createNewDB:Boolean = true;
		//private var conn:SQLConnection;
		private var createStmt:SQLStatement = new SQLStatement();
		
		//private var keyGenerator:EncryptionKeyGenerator = new EncryptionKeyGenerator();
		//private var encryptionKey:ByteArray = new ByteArray();
		
		public var password:String;
		
		[Bindable]   public var _var:Variables = Variables.getInstance();
		
		public function Bd(){
					
				
		}
		
		
/*
		public function getEncryptionKey():ByteArray{
			return encryptionKey;
		}
		public function getKeyGenerator():EncryptionKeyGenerator{
			return keyGenerator;
		}
		
	
		
		*/
		
		public function getBDSize():String{
				return dbFile.size.toString();
		}
		
		public function existeArchivo():Boolean{
			
			createNewDB=false;
			//dbFile=File.applicationStorageDirectory.resolvePath(dbFileName);
			dbFile=File.applicationDirectory.resolvePath(dbFileName);
			//Alert.show('bdsize', dbFile.size.toString(), mx.controls.Alert.OK);	
			return dbFile.exists;
			
		}
		
	
		
		
	
		////////////////////////////////////////////////////////////
		
		public function validaPassword(_password:String):String{
			password = _password;
			if (password == null || password.length <= 0)
			{
				return "Ingrese su contraseña para entrar.";
				
			}
			
			/*
			if (!keyGenerator.validateStrongPassword(password))
			{
				return "La contraseña debe ser desde 8 hasta 32 caracteres de largo. Debe contener al menos: una letra mayúscula, una letra minúscula y un número o símbolo.";
				
			}
		*/
			return "";
		}
		
		
		public function openConnection2(password:String):SQLConnection{				//EL PASSWORD CUMPLE LOS REQUISITOS MINIMOS, TRATEMOS DE ABRIR LA BASE DE DATOS
			_var.conn = new SQLConnection();
			_var.conn.addEventListener(SQLEvent.OPEN, openHandler);		//le agregamos a la conexion un listener en caso de que abra la base de datos
			_var.conn.addEventListener(SQLErrorEvent.ERROR, openError); //le agregamos a la conexion un listener en caso de que NO abra la base de datos con error
			//_var.conn.openAsync(dbFile, SQLMode.CREATE, null, false, 1024, generaEncryptionKey(password)); //Y mandamos a abrir la base de datos.
			_var.conn.openAsync(dbFile, SQLMode.CREATE, null, false, 1024);
			//_var.conn.open(dbFile, SQLMode.CREATE, false, 1024, generaEncryptionKey(password)); //Y mandamos a abrir la base de datos.
			return _var.conn;
		}
		
		/*
		public function generaEncryptionKey(password:String):ByteArray{
			return keyGenerator.getEncryptionKey(password);
		}
		
		*/
		
		private function openHandler(event:SQLEvent):void				//SE ABRIÓ LA BASE DE DATOS, VEAMOS QUE HACER..
		{
			/*var consulta:String = 										//Si la tabla pacientes no existe, la hacemos con esta consulta...
					"CREATE TABLE IF NOT EXISTS pacientes (" + 
					"    id INTEGER PRIMARY KEY AUTOINCREMENT, " + 
					"    rut TEXT, " + 
					"    nombres TEXT, " + 
					"    apellidoPaterno TEXT," + 
					"    apellidoMaterno TEXT," + 
					"    fechaNacimiento TEXT," + 
					"    sexo TEXT, " + 
					"    prevision TEXT" + 
					")";*/
			//	hacerConsulta(actualizarPacientes);			//...y mandamos a hacer la consulta.
		
				
				//actualizarPacientes();
		}
		
			
		////////////////////// METODO PARA HACER LAS CONSULTAS
	
	private function hacerConsulta(consulta:String, f:Function = null):void
	{
		var declaracion:SQLStatement= new SQLStatement();		//creamos la variable de declaracion sql:
		declaracion.sqlConnection	= _var.conn;         		//le agregamos la conexion previamente hecha...
		declaracion.text	        = consulta;					//...y le agregamos la consulta que queremos realizar
		
		declaracion.addEventListener(SQLEvent.RESULT,			//Le agregamos a la declaracion un listener que estara pendiente cuando la consulta se ejecute satisfactoriamente
			function (e:SQLEvent):void
			{
				if(f != null)
				{
					
					f(e.target.getResult());                     //hacemos que la funcion quien llamó a hacerConsulta reciba el resultado de la consulta realizada.
					//actualizarPacientes();
				}
			}
		);
		declaracion.addEventListener(SQLErrorEvent.ERROR, 		//Le agregamos a la declaración un listener que estara pendiente cuando la consulta de error
			function(event:SQLErrorEvent):void
			{
				Alert.show("Error de conexion --> "+event.error.message);
			});      
		declaracion.execute();									//Ejecutamos la declaracion.
	}      
		
		///////////////////////  ERRORES DE APERTURA DE BASE DE DATOS
	
		private function openError(event:SQLErrorEvent):void
		{
			_var.conn.removeEventListener(SQLEvent.OPEN, openHandler);
			_var.conn.removeEventListener(SQLErrorEvent.ERROR, openError);
			
			if (!createNewDB && event.error.errorID == EncryptionKeyGenerator.ENCRYPTED_DB_PASSWORD_ERROR_ID)
			{
				Alert.show('CLAVE INCORRECTA', 'Alert Box', mx.controls.Alert.OK);
			}
			else
			{
				Alert.show('BASE DE DATOS CREADA CORRECTAMENTE.', 'Alert Box', mx.controls.Alert.OK);
			}
		}			
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// HERE COMES THE QUERIES 
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		//ACTUALIZA LA LISTA DE PACIENTES EN EL DATAGRID
		
		private function actualizarPacientes(i:Object = null):void			
		{
			var consulta      :String         = "SELECT * FROM persona p, pacientes pa where p.rut=pa.rut"; 
			hacerConsulta(consulta,
				function (e:Object):void
				{
				
					_var.datosDB = new ArrayCollection(e.data);
					_var.tamanoBD=dbFile.size.toString()+" bytes.";
				}  
			);
		}
		
		// AGREGAR UN PACIENTE NUEVO
		
		public function agregaPersona(rut:String,dv:String, nombres:String, apellidoPaterno:String, apellidoMaterno:String, fechaNacimiento:String, sexo:String, direccionCalle:String,
									  direccionNum:String, mail:String, telefono:String, actividad:String,foto:String,telefonoTrabajo:String, comentario:String):void	
		{
			
			var consulta:String = 										//Si la tabla pacientes no existe, la hacemos con esta consulta...
				"INSERT INTO persona (rut, dv, nombres, apellido_paterno, apellido_materno, fecha_nacimiento, direccion_calle, direccion_num, direccion_detalle, mail, telefono, actividad, foto, telefono_trabajo" +
				", comentario,genero) VALUES (" + 
				"    '"+ rut+"', " + "    '"+ dv+"', " + 
				"    '"+ nombres+"', " + 
				"    '"+ apellidoPaterno+"', " + 
				"    '"+ apellidoMaterno+"'," + 
				"    '"+ fechaNacimiento+"'," + 
				"    '"+ direccionCalle+"'," + 
				"    '"+ direccionNum+"'," + 
				"    '"+ mail+"'," + 
				"    '"+ telefono+"'," + 
				"    '"+ actividad+"'," + 
				"    '"+ foto+"'," + 
				"    '"+ telefonoTrabajo+"'," +
				"    '"+ comentario+"'," + 
				"    '"+ sexo+"'," + ")";
			
			//Alert.show(consulta,"agrega");
			try{
				hacerConsulta(consulta);			//...y mandamos a hacer la consulta.
				
				actualizarPacientes();
			}catch (error:SQLError){}
		}
		
		
		public function agregaPaciente(rut:String, prevision:String):void	
		{
			
			
			var consulta:String = "INSERT INTO paciente (rut,id_isapre) VALUES ('"+rut+"',"+prevision+")";
			//Alert.show(consulta,"agrega");
			try{
				hacerConsulta(consulta);			//...y mandamos a hacer la consulta.
					
				actualizarPacientes();
			}catch (error:SQLError){}
		}
		
		// ACTUALIZA UN PACIENTE CON EL ID DADO
		
		public function actualizaPaciente(ru:String,pr:String):void						
		{
		//	Alert.show(_var.listaPacientes.selectedItem.id,_var.campoRut.text,Alert.OK);
			var consulta:String = "UPDATE paciente SET rut='"+ru+"', id_isapre='"+pr+"' WHERE rut='"+ru+"'";
			
			
			try{
				hacerConsulta(consulta);			//...y mandamos a hacer la consulta.
				actualizarPacientes();
			}catch (error:SQLError){}
		}
		
		public function actualizaPersona(rut:String,dv:String, nombres:String, apellidoPaterno:String, apellidoMaterno:String, fechaNacimiento:String, sexo:String, direccionCalle:String,
										 direccionNum:String, mail:String, telefono:String, actividad:String,foto:String,telefonoTrabajo:String, comentario:String):void						
		{
			//	Alert.show(_var.listaPacientes.selectedItem.id,_var.campoRut.text,Alert.OK);
			var consulta:String = "UPDATE persona SET rut='"+rut+"', nombres='"+nombres+"', apellido_paterno='"+apellidoPaterno+"', apellido_materno='"+apellidoMaterno+"', fecha_nacimiento='"+
				fechaNacimiento+"', genero='"+sexo+"', direccion_calle='"+direccionCalle+", direccion_num='"+direccionNum+"', mail ='"+mail+"', telefono='"+telefono+"', actividad='"+actividad+"',foto='"+foto+"'," +
				"telefono_trabajo='"+telefonoTrabajo+"',comentario='"+comentario+"' WHERE rut='"+rut+"'";
			
			
			try{
				hacerConsulta(consulta);			//...y mandamos a hacer la consulta.
				actualizarPacientes();
			}catch (error:SQLError){}
		}
		
		// BORRA UN PACIENTE CON EL ID DADO
		
		public function borraPaciente(rut:String):void						
		{
			
			var consulta:String = 										
				"DELETE FROM paciente WHERE rut =" + rut;
				Alert.show(consulta,"seguro",Alert.OK);
			try{
				hacerConsulta(consulta);			//...y mandamos a hacer la consulta.
				actualizarPacientes();
			}catch (error:SQLError){}
		}
		
		public function borraPersona(rut:String):void						
		{
			
			var consulta:String = 										
				"DELETE FROM persona WHERE rut =" + rut;
			Alert.show(consulta,"seguro",Alert.OK);
			try{
				hacerConsulta(consulta);			//...y mandamos a hacer la consulta.
				actualizarPacientes();
			}catch (error:SQLError){}
		}
		
		public function getIsapres(i:Object = null):void			
		{
			var consulta      :String         = "SELECT * FROM isapre"; 
			hacerConsulta(consulta,
				function (e:Object):void
				{
					
					_var.datosDB = new ArrayCollection(e.data);
					_var.tamanoBD=dbFile.size.toString()+" bytes.";
				}  
			);
		}
	}
}