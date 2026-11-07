const fs=require('fs'),vm=require('vm'),assert=require('assert'),path=require('path');
const project=path.resolve(__dirname,'..');
const capture=path.join(project,'builds','test-captures');fs.mkdirSync(capture,{recursive:true});
if(!process.argv[2])throw Error('Usage: node tools/verify.cjs /absolute/path/to/8bitworkshop/javatari/javatari.js');
process.on('uncaughtException',e=>{console.error(e.message,e.stack.split('\n').slice(-5).join('\n'));process.exit(1)});
global.window={addEventListener(){},performance:{now:()=>0},navigator:{userAgent:'node'}};
global.document={addEventListener(){}};global.Image=function(){};global.navigator=window.navigator;
vm.runInThisContext(fs.readFileSync(process.argv[2],'utf8'));
const c=new jt.AtariConsole(); let lines=[],last=[],counts=[];
c.getVideoOutput().connectMonitor({nextLine(p,vs){if(!p)return false;lines.push(Array.from(p));if((vs&&lines.length>240)||lines.length>350){last=lines;counts.push(lines.length);lines=[];return true;}return false;},synchOutput(){},showOSD(){},videoStandardDetectionStart(){},getVideoStandardDetected(){return jt.VideoStandard.NTSC}});
c.getControlsSocket().connectControls({clockPulse(){}});
c.getCartridgeSocket().insert(jt.CartridgeDatabase.createCartridgeFromRom(new jt.ROM('BlockWorld.bin',Array.from(fs.readFileSync(path.join(project,'builds/LEGO_Block_World.bin'))))),false); c.powerOn(true);
const symbols={};for(const l of fs.readFileSync(path.join(project,'builds/LEGO_Block_World.sym'),'utf8').split('\n')){const m=l.match(/^(\w+)\s+([0-9a-f]{4})\s/);if(m)symbols[m[1]]=parseInt(m[2],16);}
function r(s){assert(s in symbols,s);return c.readAddress(symbols[s]);}
function status(){return Object.fromEntries(['world','bricks','bridge','rescued','hp','player1x','player1y','player0x','velocity','grounded','hearts','state','invincible'].map(s=>[s,r(s)]));}
let held=[];
function frames(n,keys=[]){for(const k of held)if(!keys.includes(k))c.getControlsSocket().controlStateChanged(k,false);for(const k of keys)if(!held.includes(k))c.getControlsSocket().controlStateChanged(k,true);held=keys;for(let i=0;i<n;i++)c.clockPulse();}
function shot(name){fs.writeFileSync(path.join(capture,name+'.json'),JSON.stringify(last));}
function walk(x,max=200){for(let i=0;i<max&&r('player1x')!==x;i++)frames(1,[r('player1x')<x?14:13]);assert.equal(r('player1x'),x);}

frames(30);shot('title');frames(1,[15]);frames(70);
assert.equal(r('state'),1);assert.equal(r('hearts'),3);
// Holding fire must not retrigger jumping after landing.
frames(75,[15]);assert.equal(r('grounded'),1);frames(1);
const campaignStart=counts.length;
for(let w=0;w<6;w++){
 assert.equal(r('world'),w);frames(60);shot('world'+(w+1));
 walk(30);assert.equal(r('bricks'),1);
 frames(1,[15]);walk(r('ledgex')+8);frames(50);assert.equal(r('bricks'),2);
 walk(62);frames(40);assert.equal(r('bricks'),3);
 frames(3,[11]);assert.equal(r('bridge'),1);shot('built'+(w+1));
 walk(99);frames(1,[15]);
 for(let i=0;i<500&&r('hp')>0&&r('hearts')>0;i++){
  const keys=[];
  if(r('player1x')<r('player0x'))keys.push(14);else if(r('player1x')>r('player0x'))keys.push(13);
  if(r('grounded'))keys.push(15);frames(1,keys);
 }
 assert.equal(r('hp'),0,'enemy world '+w);assert.equal(r('hearts'),3,'no damage world '+w);
 frames(50);walk(142);frames(3,[11]);assert.equal(r('world'),w,'portal requires rescue');assert.equal(r('rescued'),0);walk(126);frames(3,[11]);assert.equal(r('rescued'),1);shot('rescued'+(w+1));
 walk(142);frames(12,[11]);
 console.log('World '+(w+1)+' completed: '+JSON.stringify(status()));
}
assert.equal(r('state'),3);shot('victory');frames(10);assert.equal(r('state'),3);
const campaignEnd=counts.length;
// Reset returns to title and Select changes the relay mode once per press.
frames(2,[54]);frames(30);assert.equal(r('state'),0);
frames(10,[53]);assert.equal(r('mode'),1);frames(1);frames(3,[53]);assert.equal(r('mode'),0);
frames(1);frames(1,[53]);frames(1);frames(1,[15]);frames(70);assert.equal(r('mode'),1);
// No bridge: walking into the gap loses exactly one life and changes relay turn.
walk(66);frames(30,[14]);frames(40);assert.equal(r('hearts'),2);assert.equal(r('turn'),1);assert.equal(r('bridge'),0);
frames(100);walk(66);frames(30,[14]);frames(40);assert.equal(r('hearts'),1);assert.equal(r('turn'),0);
frames(100);walk(66);frames(30,[14]);frames(50);assert.equal(r('state'),2);shot('gameover');
frames(1);frames(1,[15]);frames(30);assert.equal(r('state'),0);
// Side contact costs a life and preserves construction progress.
frames(1,[15]);frames(70);walk(30);frames(1,[15]);walk(r('ledgex')+8);frames(50);walk(62);frames(40);frames(3,[11]);
for(let i=0;i<140&&r('hearts')===3;i++)frames(1,[14]);
assert.equal(r('hearts'),2);assert.equal(r('bridge'),1);assert.equal(r('bricks'),3);assert.equal(r('player1x'),22);
const histogram={};for(const n of counts.slice(campaignStart,campaignEnd))histogram[n]=(histogram[n]||0)+1;
console.log('Campaign frame lengths:',histogram);
fs.writeFileSync(path.join(capture,'framecounts.json'),JSON.stringify(counts));
console.log('PASS: six worlds, 3-hit boss, rescue, bridge, victory, held fire, reset, relay, pit deaths, side damage, preserved bridge, game over, restart.');
