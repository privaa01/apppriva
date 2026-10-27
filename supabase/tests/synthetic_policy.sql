-- SOLO laboratorio local con datos sintéticos. Nunca habilitar en producción.
insert into public.treatment_policies(version, body, is_active, is_test, purposes)
values (
  'test-2026-10-27',
  'Política de prueba: usa únicamente datos ficticios. Nombre para saludo; correo para identificación y recuperación. No es una política para usuarios reales.',
  true,
  true,
  array['Saludo personalizado', 'Identificación de cuenta', 'Recuperación de acceso']
);
