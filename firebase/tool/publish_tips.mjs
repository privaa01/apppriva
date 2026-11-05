import {readFile, mkdir, writeFile} from 'node:fs/promises';
import {resolve} from 'node:path';
import {pathToFileURL} from 'node:url';

const project='priva-785cb';
const ids=['passwords','sharing','links','profiles'];
const root=`projects/${project}/databases/(default)`;
const endpoint=`https://firestore.googleapis.com/v1/${root}/documents`;
const payloadUrl=new URL('../content/tips-1.0.0.json',import.meta.url);
export function validatePayload(payload){
 if(!payload || Object.keys(payload).length!==4 || ids.some(id=>!Object.hasOwn(payload,id)))throw new Error('Invalid category set');
 for(const id of ids){
  const d=payload[id];
  const fields=['schemaVersion','contentVersion','categoryId','status','catalogTitle','description',
   'title','panelTitle','recommendations','example','explanation','advice','clarification','editorialReview'];
  const exact=(value,keys)=>value&&typeof value==='object'&&Object.keys(value).length===keys.length&&keys.every(k=>Object.hasOwn(value,k));
  const text=v=>typeof v==='string'&&v.trim().length>0;
  const variants={passwords:['kind','label','fictionalLabel','value','caption'],
   sharing:['kind','label','fictionalLabel','body','caption'],
   links:['kind','label','fictionalLabel','body','address','caption'],
   profiles:['kind','label','fictionalLabel','name','handle','signals','avatar']};
  if(!exact(d,fields)||!exact(d.example,variants[id])||
   !exact(d.editorialReview,['version','approvedOn','sourceIds'])||
   !['catalogTitle','description','title','panelTitle','explanation','advice'].every(k=>text(d[k]))||
   typeof d.clarification!=='string'||(['links','profiles'].includes(id)&&!text(d.clarification))||
   !d.recommendations?.every(text)||
   !Object.entries(d.example).every(([k,v])=>k==='signals'?Array.isArray(v)&&v.length===3&&v.every(text):text(v))||
   d.example.kind!==({passwords:'password',sharing:'post',links:'message',profiles:'profile'})[id]||
   d.example.label!=='Ejemplo'||(id==='links'&&d.example.address!=='www.premio-regalo.example')||
   (id==='profiles'&&d.example.avatar!=='person')||
   !d.editorialReview.sourceIds?.every(x=>['N1','F4','G1','F1','F2a','F3a','R1','R2','H1'].includes(x)))throw new Error('Invalid approved payload');
  if(d.categoryId!==id||d.schemaVersion!==1||d.contentVersion!=='tips-1.0.0'||d.status!=='approved'||
    d.editorialReview?.version!=='1.0.0'||d.editorialReview?.approvedOn!=='2026-11-04'||
    !Array.isArray(d.editorialReview?.sourceIds)||d.editorialReview.sourceIds.length===0||
    !Array.isArray(d.recommendations)||d.recommendations.length!==3||
    Buffer.byteLength(JSON.stringify(d),'utf8')>32768)throw new Error('Invalid approved payload');
 }
 return payload;
}
function typed(value){
 if(typeof value==='string')return {stringValue:value};
 if(Number.isInteger(value))return {integerValue:String(value)};
 if(Array.isArray(value))return {arrayValue:{values:value.map(typed)}};
 if(value && typeof value==='object')return {mapValue:{fields:Object.fromEntries(Object.entries(value).map(([k,v])=>[k,typed(v)]))}};
 throw new Error('Unsupported payload type');
}
function canonical(value){
 if(Array.isArray(value))return value.map(canonical);
 if(value&&typeof value==='object')return Object.fromEntries(Object.keys(value).sort().map(k=>[k,canonical(value[k])]));
 return value;
}
export async function main(args, dependencies={}){
 const allowed=new Set(['--validate','--check','--apply','--backup-dir']);
 let mode='--validate',backup;
 for(let i=0;i<args.length;i++){
  if(!allowed.has(args[i]))throw new Error('Unsupported argument');
  if(args[i]==='--backup-dir')backup=args[++i];else mode=args[i];
 }
 if(mode==='--apply'&&(!backup||resolve(backup).startsWith(resolve(new URL('../..',import.meta.url).pathname)))){
  throw new Error('An external backup directory is required');
 }
 const payload=validatePayload(dependencies.payload ?? JSON.parse(await readFile(payloadUrl,'utf8')));
 if(mode==='--validate'){console.log('Validated four approved public documents. No network writes.');return;}
 let client=dependencies.client;
 if(!client){
  const {GoogleAuth}=await import('google-auth-library');
  client=await new GoogleAuth({projectId:project,scopes:['https://www.googleapis.com/auth/datastore']}).getClient();
 }
 const documents={};const writes=[];
 for(const id of ids){
  const name=`${root}/documents/educational_tips/${id}`;
  let current=null;
  try{current=(await client.request({url:`${endpoint}/educational_tips/${id}`,method:'GET',timeout:20000})).data;}
  catch(error){if(error.response?.status!==404)throw error;}
  documents[id]=current;
  const fields=typed(payload[id]).mapValue.fields;
  if(current){
   if(JSON.stringify(canonical(current.fields))!==JSON.stringify(canonical(fields))){
    throw new Error(`Conflicting existing public content: ${id}. Nothing written.`);
   }
   continue;
  }
  writes.push({update:{name,fields},currentDocument:{exists:false}});
 }
 if(mode==='--check'){console.log(`Read-only check complete: ${writes.length} missing, ${4-writes.length} identical. Nothing written.`);return;}
 await mkdir(backup,{recursive:true,mode:0o700});
 await writeFile(resolve(backup,'educational-tips-before.json'),JSON.stringify({project,documents},null,2),{flag:'wx',mode:0o600});
 if(writes.length){
  await client.request({url:`${endpoint}:commit`,method:'POST',data:{writes},timeout:20000});
 }
 console.log(`Atomic content publication complete: ${writes.length} created. Rules and other collections untouched.`);
}
if(process.argv[1] && import.meta.url===pathToFileURL(resolve(process.argv[1])).href){
 main(process.argv.slice(2)).catch(error=>{
  // Never print OAuth responses, headers, tokens, credential paths or user data.
  const status=error.response?.status;
  console.error(status?`Publication failed: HTTP ${status}; no credential details logged.`:
   ['Invalid category set','Invalid approved payload','Unsupported payload type','Unsupported argument','An external backup directory is required'].includes(error.message)||error.message.startsWith('Conflicting existing public content:')
    ?error.message:'Publication unavailable. Check authorized ADC access and the backup directory.');
  process.exitCode=1;
 });
}
