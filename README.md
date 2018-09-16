# docker-protoc
Docker image with Microsoft DirectX shader compiler

Hub: https://hub.docker.com/r/gwihlidal/dxc/

## Usage
```
$ docker run --rm gwihlidal/dxc -help
```

```
$ docker run --rm -v $(pwd):$(pwd) -w $(pwd) gwihlidal/dxc -T <target> -E <entry-point-name> <input-hlsl-file>
```

## Example Output

```
$ docker run --rm -v h:/Repositories/docker-dxc:/tests -w /tests gwihlidal/dxc -T cs_6_0 -E main test.hlsl
warning: DXIL.dll not found.  Resulting DXIL will not be signed for use in release environments.

;
; Input signature:
;
; Name                 Index   Mask Register SysValue  Format   Used
; -------------------- ----- ------ -------- -------- ------- ------
; no parameters
;
; Output signature:
;
; Name                 Index   Mask Register SysValue  Format   Used
; -------------------- ----- ------ -------- -------- ------- ------
; no parameters
;
; Pipeline Runtime Information:
;
;
;
; Buffer Definitions:
;
; Resource bind info for Buffer0
; {
;
;   struct struct.Pixel
;   {
;
;       int colour;                                   ; Offset:    0
;
;   } $Element;                                       ; Offset:    0 Size:     4
;
; }
;
; Resource bind info for BufferOut
; {
;
;   struct struct.Pixel
;   {
;
;       int colour;                                   ; Offset:    0
;
;   } $Element;                                       ; Offset:    0 Size:     4
;
; }
;
;
; Resource Bindings:
;
; Name                                 Type  Format         Dim      ID      HLSL Bind  Count
; ------------------------------ ---------- ------- ----------- ------- -------------- ------
; Buffer0                           texture  struct         r/o      T0             t0     1
; BufferOut                             UAV  struct         r/w      U0             u0     1
;
target datalayout = "e-m:e-p:32:32-i1:32-i8:32-i16:32-i32:32-i64:64-f16:32-f32:32-f:64:64-n8:16:32:64"
target triple = "dxil-ms-dx"

%dx.types.Handle = type { i8* }
%dx.types.ResRet.i32 = type { i32, i32, i32, i32, i32 }
%class.StructuredBuffer = type { %struct.Pixel }
%struct.Pixel = type { i32 }
%class.RWStructuredBuffer = type { %struct.Pixel }

define void @main() {
  %BufferOut_UAV_structbuf = call %dx.types.Handle @dx.op.createHandle(i32 57, i8 1, i32 0, i32 0, i1 false)  ; CreateHandle(resourceClass,rangeId,index,nonUniformIndex)
  %Buffer0_texture_structbuf = call %dx.types.Handle @dx.op.createHandle(i32 57, i8 0, i32 0, i32 0, i1 false)  ; CreateHandle(resourceClass,rangeId,index,nonUniformIndex)
  %1 = call i32 @dx.op.threadId.i32(i32 93, i32 0)  ; ThreadId(component)
  %2 = call i32 @dx.op.threadId.i32(i32 93, i32 1)  ; ThreadId(component)
  %3 = shl i32 %2, 10
  %4 = add nsw i32 %3, %1
  %5 = call %dx.types.ResRet.i32 @dx.op.bufferLoad.i32(i32 68, %dx.types.Handle %Buffer0_texture_structbuf, i32 %4, i32 0)  ; BufferLoad(srv,index,wot)
  %6 = extractvalue %dx.types.ResRet.i32 %5, 0
  %7 = and i32 %6, 255
  %8 = uitofp i32 %7 to float
  %9 = lshr i32 %6, 8
  %10 = and i32 %9, 255
  %11 = uitofp i32 %10 to float
  %12 = lshr i32 %6, 16
  %13 = and i32 %12, 255
  %14 = uitofp i32 %13 to float
  %15 = fmul fast float %8, 0x3F534679C0000000
  %16 = fmul fast float %11, 0x3F62F43BE0000000
  %17 = fadd fast float %16, %15
  %18 = fmul fast float %14, 0x3F3C453B20000000
  %19 = fadd fast float %17, %18
  %FMax6 = call float @dx.op.binary.f32(i32 35, float %19, float 0.000000e+00)  ; FMax(a,b)
  %FMin7 = call float @dx.op.binary.f32(i32 36, float %FMax6, float 1.000000e+00)  ; FMin(a,b)
  %20 = fmul fast float %FMin7, 2.550000e+02
  %21 = fptosi float %20 to i32
  %22 = mul i32 %21, 65793
  call void @dx.op.bufferStore.i32(i32 69, %dx.types.Handle %BufferOut_UAV_structbuf, i32 %4, i32 0, i32 %22, i32 undef, i32 undef, i32 undef, i8 1)  ; BufferStore(uav,coord0,coord1,value0,value1,value2,value3,mask)
  ret void
}

; Function Attrs: nounwind readnone
declare i32 @dx.op.threadId.i32(i32, i32) #0

; Function Attrs: nounwind readnone
declare float @dx.op.binary.f32(i32, float, float) #0

; Function Attrs: nounwind readonly
declare %dx.types.Handle @dx.op.createHandle(i32, i8, i32, i32, i1) #1

; Function Attrs: nounwind
declare void @dx.op.bufferStore.i32(i32, %dx.types.Handle, i32, i32, i32, i32, i32, i32, i8) #2

; Function Attrs: nounwind readonly
declare %dx.types.ResRet.i32 @dx.op.bufferLoad.i32(i32, %dx.types.Handle, i32, i32) #1

attributes #0 = { nounwind readnone }
attributes #1 = { nounwind readonly }
attributes #2 = { nounwind }

!llvm.ident = !{!0}
!dx.version = !{!1}
!dx.valver = !{!2}
!dx.shaderModel = !{!3}
!dx.resources = !{!4}
!dx.typeAnnotations = !{!10, !15}
!dx.entryPoints = !{!19}

!0 = !{!"clang version 3.7 (tags/RELEASE_370/final)"}
!1 = !{i32 1, i32 0}
!2 = !{i32 1, i32 3}
!3 = !{!"cs", i32 6, i32 0}
!4 = !{!5, !8, null, null}
!5 = !{!6}
!6 = !{i32 0, %class.StructuredBuffer* undef, !"Buffer0", i32 0, i32 0, i32 1, i32 12, i32 0, !7}
!7 = !{i32 1, i32 4}
!8 = !{!9}
!9 = !{i32 0, %class.RWStructuredBuffer* undef, !"BufferOut", i32 0, i32 0, i32 1, i32 12, i1 false, i1 false, i1 false, !7}
!10 = !{i32 0, %class.StructuredBuffer undef, !11, %struct.Pixel undef, !13, %class.RWStructuredBuffer undef, !11}
!11 = !{i32 4, !12}
!12 = !{i32 6, !"h", i32 3, i32 0}
!13 = !{i32 4, !14}
!14 = !{i32 6, !"colour", i32 3, i32 0, i32 7, i32 4}
!15 = !{i32 1, void ()* @main, !16}
!16 = !{!17}
!17 = !{i32 0, !18, !18}
!18 = !{}
!19 = !{void ()* @main, !"main", null, !4, !20}
!20 = !{i32 0, i64 16, i32 4, !21}
!21 = !{i32 32, i32 16, i32 1}
```
