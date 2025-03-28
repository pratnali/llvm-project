; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --version 4
; RUN: opt -passes=ipsccp -S %s | FileCheck %s

define i16 @range_from_and_nuw(i32 %a) {
; CHECK-LABEL: define i16 @range_from_and_nuw(
; CHECK-SAME: i32 [[A:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[AND1:%.*]] = and i32 [[A]], 65535
; CHECK-NEXT:    [[TRUNC1:%.*]] = trunc nuw i32 [[AND1]] to i16
; CHECK-NEXT:    ret i16 [[TRUNC1]]
;
entry:
  %and1 = and i32 %a, 65535
  %trunc1 = trunc i32 %and1 to i16
  ret i16 %trunc1
}

define i8 @range_from_or_nsw(i16 %a) {
; CHECK-LABEL: define range(i8 -128, 0) i8 @range_from_or_nsw(
; CHECK-SAME: i16 [[A:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[AND1:%.*]] = or i16 [[A]], -128
; CHECK-NEXT:    [[TRUNC1:%.*]] = trunc nsw i16 [[AND1]] to i8
; CHECK-NEXT:    ret i8 [[TRUNC1]]
;
entry:
  %and1 = or i16 %a, 65408
  %trunc1 = trunc i16 %and1 to i8
  ret i8 %trunc1
}

define i16 @range_from_and_nuw_nsw(i32 %a) {
; CHECK-LABEL: define range(i16 0, -32768) i16 @range_from_and_nuw_nsw(
; CHECK-SAME: i32 [[A:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[AND1:%.*]] = and i32 [[A]], 32767
; CHECK-NEXT:    [[TRUNC1:%.*]] = trunc nuw nsw i32 [[AND1]] to i16
; CHECK-NEXT:    ret i16 [[TRUNC1]]
;
entry:
  %and1 = and i32 %a, 32767
  %trunc1 = trunc i32 %and1 to i16
  ret i16 %trunc1
}

define <4 x i16> @range_from_and_nuw_vec(<4 x i32> %a) {
; CHECK-LABEL: define <4 x i16> @range_from_and_nuw_vec(
; CHECK-SAME: <4 x i32> [[A:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[AND1:%.*]] = and <4 x i32> [[A]], splat (i32 65535)
; CHECK-NEXT:    [[TRUNC1:%.*]] = trunc nuw <4 x i32> [[AND1]] to <4 x i16>
; CHECK-NEXT:    ret <4 x i16> [[TRUNC1]]
;
entry:
  %and1 = and <4 x i32> %a, <i32 65535, i32 65535, i32 65535, i32 65535>
  %trunc1 = trunc <4 x i32> %and1 to <4 x i16>
  ret <4 x i16> %trunc1
}

define i4 @range_from_sge_sle(i8 %a) {
; CHECK-LABEL: define i4 @range_from_sge_sle(
; CHECK-SAME: i8 [[A:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SGT:%.*]] = icmp sge i8 [[A]], 0
; CHECK-NEXT:    [[SLT:%.*]] = icmp sle i8 [[A]], 15
; CHECK-NEXT:    [[AND:%.*]] = and i1 [[SGT]], [[SLT]]
; CHECK-NEXT:    br i1 [[AND]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    [[AND1:%.*]] = and i8 [[A]], 7
; CHECK-NEXT:    [[TRUNC1:%.*]] = trunc nuw i8 [[A]] to i4
; CHECK-NEXT:    [[TRUNC2:%.*]] = trunc nuw nsw i8 [[AND1]] to i4
; CHECK-NEXT:    [[XOR1:%.*]] = xor i4 [[TRUNC1]], [[TRUNC2]]
; CHECK-NEXT:    ret i4 [[XOR1]]
; CHECK:       else:
; CHECK-NEXT:    [[TRUNC3:%.*]] = trunc i8 [[A]] to i4
; CHECK-NEXT:    ret i4 [[TRUNC3]]
;
entry:
  %sgt = icmp sge i8 %a, 0
  %slt = icmp sle i8 %a, 15
  %and = and i1 %sgt, %slt
  br i1 %and, label %then, label %else

then:
  %and1 = and i8 %a, 7

  %trunc1 = trunc i8 %a to i4
  %trunc2 = trunc i8 %and1 to i4
  %xor1 = xor i4 %trunc1, %trunc2
  ret i4 %xor1

else:
  %trunc3 = trunc i8 %a to i4
  ret i4 %trunc3
}

define i16 @range_from_sext(i16 %a) {
; CHECK-LABEL: define i16 @range_from_sext(
; CHECK-SAME: i16 [[A:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SEXT1:%.*]] = sext i16 [[A]] to i32
; CHECK-NEXT:    [[TRUNC1:%.*]] = trunc nsw i32 [[SEXT1]] to i16
; CHECK-NEXT:    ret i16 [[TRUNC1]]
;
entry:
  %sext1 = sext i16 %a to i32
  %trunc1 = trunc i32 %sext1 to i16
  ret i16 %trunc1
}

define i16 @range_from_zext(i16 %a) {
; CHECK-LABEL: define i16 @range_from_zext(
; CHECK-SAME: i16 [[A:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ZEXT1:%.*]] = zext i16 [[A]] to i32
; CHECK-NEXT:    [[TRUNC1:%.*]] = trunc nuw i32 [[ZEXT1]] to i16
; CHECK-NEXT:    ret i16 [[TRUNC1]]
;
entry:
  %zext1 = zext i16 %a to i32
  %trunc1 = trunc i32 %zext1 to i16
  ret i16 %trunc1
}

define i1 @range_from_select_i1_nuw(i1 %c) {
; CHECK-LABEL: define i1 @range_from_select_i1_nuw(
; CHECK-SAME: i1 [[C:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SELECT1:%.*]] = select i1 [[C]], i16 0, i16 1
; CHECK-NEXT:    [[TRUNC1:%.*]] = trunc nuw i16 [[SELECT1]] to i1
; CHECK-NEXT:    ret i1 [[TRUNC1]]
;
entry:
  %select1 = select i1 %c, i16 0, i16 1
  %trunc1 = trunc i16 %select1 to i1
  ret i1 %trunc1
}

define i1 @range_from_select_i1_nsw(i1 %c) {
; CHECK-LABEL: define i1 @range_from_select_i1_nsw(
; CHECK-SAME: i1 [[C:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SELECT1:%.*]] = select i1 [[C]], i16 0, i16 -1
; CHECK-NEXT:    [[TRUNC1:%.*]] = trunc nsw i16 [[SELECT1]] to i1
; CHECK-NEXT:    ret i1 [[TRUNC1]]
;
entry:
  %select1 = select i1 %c, i16 0, i16 -1
  %trunc1 = trunc i16 %select1 to i1
  ret i1 %trunc1
}

define i1 @range_from_select_i1_fail(i1 %c) {
; CHECK-LABEL: define i1 @range_from_select_i1_fail(
; CHECK-SAME: i1 [[C:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SELECT1:%.*]] = select i1 [[C]], i16 1, i16 -1
; CHECK-NEXT:    [[TRUNC1:%.*]] = trunc i16 [[SELECT1]] to i1
; CHECK-NEXT:    ret i1 [[TRUNC1]]
;
entry:
  %select1 = select i1 %c, i16 1, i16 -1
  %trunc1 = trunc i16 %select1 to i1
  ret i1 %trunc1
}

define i8 @range_from_trunc_fail(i32 %a) {
; CHECK-LABEL: define i8 @range_from_trunc_fail(
; CHECK-SAME: i32 [[A:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TRUNC1:%.*]] = trunc i32 [[A]] to i16
; CHECK-NEXT:    [[TRUNC2:%.*]] = trunc i16 [[TRUNC1]] to i8
; CHECK-NEXT:    ret i8 [[TRUNC2]]
;
entry:
  %trunc1 = trunc i32 %a to i16
  %trunc2 = trunc i16 %trunc1 to i8
  ret i8 %trunc2
}
