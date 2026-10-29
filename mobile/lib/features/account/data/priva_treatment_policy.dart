import 'account_models.dart';

const privaPolicyVersion = 'priva-1.0.0';
const privaPolicyPurposes = [
  'personalized_greeting',
  'account_access_recovery',
];

const privaTreatmentPolicy = TreatmentPolicy(
  version: privaPolicyVersion,
  isTest: false,
  purposes: [
    'Usar el nombre para personalizar el saludo.',
    'Usar el correo para identificar la cuenta, verificarlo y recuperar el acceso.',
  ],
  body: '''El equipo de Priva es responsable del resguardo de los datos personales.
Para consultas, actualización, rectificación, prueba de autorización, revocatoria
o solicitud de eliminación, escribe a priva202611@gmail.com desde el correo
asociado a tu cuenta. Verificaremos tu identidad de forma proporcional para atender
la solicitud. La eliminación se solicita por ese canal; no es automática al cerrar
sesión y está sujeta a las obligaciones aplicables debidamente justificadas.

Solicitamos nombre y correo para las finalidades indicadas. No solicitamos teléfono
ni utilizamos SMS. Firebase Authentication gestiona la contraseña y verificación;
Priva no guarda contraseñas en texto legible. La recuperación envía un enlace al correo.
Cloud Firestore conserva el nombre de perfil y la evidencia de autorización: ID de
cuenta, versión de política, finalidades, acción de aceptación y fecha de servidor.
La evidencia no contiene tu contraseña, códigos, dirección IP ni datos del dispositivo.

El tratamiento utiliza servicios de Firebase de Google. El acceso a los datos se
restringe según la cuenta y las funciones autorizadas. Se conservan únicamente
mientras sean necesarios para la finalidad o exista una obligación justificada.
No se fija un plazo universal ni se garantiza eliminación instantánea de respaldos.
No autorizas publicidad al crear la cuenta.

Las respuestas y resultados del cuestionario no se guardan: su uso será temporal,
educativo y orientativo. Verificar tu correo no sustituye tu autorización de datos.
Puedes consultar esta política antes de aceptar; la casilla no está premarcada.

Versión priva-1.0.0. Los cambios de finalidades deberán comunicarse y someterse a
la autorización que corresponda. Esta información no garantiza protección absoluta.''',
);
