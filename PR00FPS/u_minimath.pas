unit u_minimath;

interface

{ MinValue: Returns the smallest signed value in the data array (MIN) }
function MinValue(const Data: array of Double): Double;
function MinIntValue(const Data: array of Integer): Integer;

function Min(const A, B: Integer): Integer; overload;
function Min(const A, B: Int64): Int64; overload;
function Min(const A, B: Single): Single; overload;
function Min(const A, B: Double): Double; overload;
function Min(const A, B: Extended): Extended; overload;

{ MaxValue: Returns the largest signed value in the data array (MAX) }
function MaxValue(const Data: array of Double): Double;
function MaxIntValue(const Data: array of Integer): Integer;

function Max(const A, B: Integer): Integer; overload;
function Max(const A, B: Int64): Int64; overload;
function Max(const A, B: Single): Single; overload;
function Max(const A, B: Double): Double; overload;
function Max(const A, B: Extended): Extended; overload;

function RadToDeg(const Radians: Extended): Extended;
function DegToRad(const Degrees: Extended): Extended;

function ArcSin(const X: Extended): Extended;
function ArcCos(const X: Extended): Extended;

implementation

function MinValue(const Data: array of Double): Double;
var
  I: Integer;
begin
  Result := Data[Low(Data)];
  for I := Low(Data) + 1 to High(Data) do
    if Result > Data[I] then
      Result := Data[I];
end;

function MinIntValue(const Data: array of Integer): Integer;
var
  I: Integer;
begin
  Result := Data[Low(Data)];
  for I := Low(Data) + 1 to High(Data) do
    if Result > Data[I] then
      Result := Data[I];
end;

function Min(const A, B: Integer): Integer;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

function Min(const A, B: Int64): Int64;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

function Min(const A, B: Single): Single;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

function Min(const A, B: Double): Double;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

function Min(const A, B: Extended): Extended;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

function MaxValue(const Data: array of Double): Double;
var
  I: Integer;
begin
  Result := Data[Low(Data)];
  for I := Low(Data) + 1 to High(Data) do
    if Result < Data[I] then
      Result := Data[I];
end;

function MaxIntValue(const Data: array of Integer): Integer;
var
  I: Integer;
begin
  Result := Data[Low(Data)];
  for I := Low(Data) + 1 to High(Data) do
    if Result < Data[I] then
      Result := Data[I];
end;

function Max(const A, B: Integer): Integer;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

function Max(const A, B: Int64): Int64;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

function Max(const A, B: Single): Single;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

function Max(const A, B: Double): Double;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

function Max(const A, B: Extended): Extended;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

function DegToRad(const Degrees: Extended): Extended;
begin
  Result := Degrees * (PI / 180);
end;

function RadToDeg(const Radians: Extended): Extended;
begin
  Result := Radians * (180 / PI);
end;

function ArcTan2(const Y, X: Extended): Extended;
asm
        FLD     Y
        FLD     X
        FPATAN
        FWAIT
end;

function ArcSin(const X: Extended): Extended;
begin
  Result := ArcTan2(X, Sqrt(1 - X * X))
end;

function ArcCos(const X: Extended): Extended;
begin
  Result := ArcTan2(Sqrt(1 - X * X), X);
end;

end.
 