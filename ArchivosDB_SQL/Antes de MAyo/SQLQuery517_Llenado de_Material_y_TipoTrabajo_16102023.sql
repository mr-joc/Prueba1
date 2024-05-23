USE AllCeramic2024
go


------INSERT tbMaterial(strNombre,strNombreCorto,isActivo,isBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta,strUsuarioMod,strMaquinaMod,datFechaMod)
--SELECT 
--strNombre,strNombreCorto,isActivo=intActivo,isBorrado=0,strUsuarioAlta,strMaquinaAlta,datFechaAlta,strUsuarioMod,strMaquinaMod,datFechaMod
--FROM LabAllCeramic.dbo.tbMaterial
--ORDER BY intMaterial




--SELECT * FROM LabAllCeramic.dbo.tbMaterial
--SELECT * FROM tbMaterial
--go

------INSERT tbTipoTrabajo(strNombre,strNombreCorto,intMaterial,dblPrecio,dblPrecioUrgencia,isActivo,isBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta,strUsuarioMod,strMaquinaMod,datFechaMod)
--select --intTipoTrabajo,
--	strNombre,strNombreCorto,intMaterial,dblPrecio,dblPrecioUrgencia,isActivo=intActivo,isBorrado=0,strUsuarioAlta,strMaquinaAlta,datFechaAlta,strUsuarioMod,strMaquinaMod,datFechaMod
--FROM LabAllCeramic.dbo.tbTipoTrabajo
--WHERE intTipoTrabajo <= 25
--ORDER BY intTipoTrabajo


------INSERT tbTipoTrabajo(strNombre,strNombreCorto,intMaterial,dblPrecio,dblPrecioUrgencia,isActivo,isBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta,strUsuarioMod,strMaquinaMod,datFechaMod)
--select --intTipoTrabajo,
--	strNombre,strNombreCorto,intMaterial,dblPrecio,dblPrecioUrgencia,isActivo=intActivo,isBorrado=0,strUsuarioAlta,strMaquinaAlta,datFechaAlta,strUsuarioMod,strMaquinaMod,datFechaMod
--FROM LabAllCeramic.dbo.tbTipoTrabajo
--WHERE intTipoTrabajo  = 25
--ORDER BY intTipoTrabajo


------INSERT tbTipoTrabajo(strNombre,strNombreCorto,intMaterial,dblPrecio,dblPrecioUrgencia,isActivo,isBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta,strUsuarioMod,strMaquinaMod,datFechaMod)
--select --intTipoTrabajo,
--	strNombre,strNombreCorto,intMaterial,dblPrecio,dblPrecioUrgencia,isActivo=intActivo,isBorrado=0,strUsuarioAlta,strMaquinaAlta,datFechaAlta,strUsuarioMod,strMaquinaMod,datFechaMod
--FROM LabAllCeramic.dbo.tbTipoTrabajo
--WHERE intTipoTrabajo  >=27
--ORDER BY intTipoTrabajo

--UPDATE tbTipoTrabajo SET strNombre = '-****--REPETIDO--***-'+strNombre+'-****--REPETIDO--***-', isActivo=0, isBorrado=1 where intTipoTrabajo = 26




 --select * FROM LabAllCeramic.dbo.tbTipoTrabajo	 order by inttipotrabajo
--select * FROM tbTipoTrabajo						 order by inttipotrabajo


--SELECT * FROm tbMaterial
SELECT * FROm tbTipoTrabajo
