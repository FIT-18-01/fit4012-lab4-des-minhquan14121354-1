#!/usr/bin/env pwsh
Set-StrictMode -Version Latest

function Fail($msg) {
	Write-Error "[FAIL] $msg"
	exit 1
}

function Pass($msg) {
	Write-Output "[PASS] $msg"
}

function FileExists($path) {
	if (!(Test-Path $path -PathType Leaf)) { Fail "Thiếu file bắt buộc: $path" }
}

function DirExists($path) {
	if (!(Test-Path $path -PathType Container)) { Fail "Thiếu thư mục bắt buộc: $path/" }
}

function ContainsCI($path, $pattern) {
	try {
		$res = Select-String -Path $path -Pattern $pattern -SimpleMatch -Quiet -ErrorAction Stop
		return $res
	} catch {
		return $false
	}
}

# Basic required files and directories
FileExists "des.cpp"
FileExists "README.md"
FileExists "report-1page.md"
DirExists "tests"
DirExists "logs"
Pass "Đủ các file/thư mục bắt buộc cơ bản."

# Tests count
$testCount = (Get-ChildItem -Path tests -File -ErrorAction SilentlyContinue | Measure-Object).Count
if ($testCount -lt 5) { Fail "Thư mục tests/ phải có ít nhất 5 file test. Hiện có: $testCount" }
Pass "Thư mục tests/ có ít nhất 5 file test."

# README content checks (case-insensitive regex)
$rREADME = Get-Item README.md
if (-not (Select-String -Path README.md -Pattern 'how to run|cách chạy|build and run|compile|biên dịch' -IgnoreCase -Quiet)) {
	Fail "README.md phải có hướng dẫn chạy chương trình (how to run / cách chạy)."
}
if (-not (Select-String -Path README.md -Pattern 'input|đầu vào' -IgnoreCase -Quiet)) {
	Fail "README.md phải mô tả input/đầu vào."
}
if (-not (Select-String -Path README.md -Pattern 'output|đầu ra' -IgnoreCase -Quiet)) {
	Fail "README.md phải mô tả output/đầu ra."
}
if (-not (Select-String -Path README.md -Pattern 'padding' -IgnoreCase -Quiet)) {
	Fail "README.md phải giải thích padding đang dùng hoặc không dùng."
}
if (-not (Select-String -Path README.md -Pattern 'ethics|safe use|an toàn|đạo đức' -IgnoreCase -Quiet)) {
	Fail "README.md phải có mục Ethics & Safe use / an toàn sử dụng."
}
Pass "README.md có các mục tối thiểu theo yêu cầu."

# report checks
if (-not (Select-String -Path report-1page.md -Pattern 'mục tiêu|objective' -IgnoreCase -Quiet)) {
	Fail "report-1page.md phải có mục Mục tiêu / Objective."
}
if (-not (Select-String -Path report-1page.md -Pattern 'cách làm|phương pháp|approach|method' -IgnoreCase -Quiet)) {
	Fail "report-1page.md phải có mục Cách làm / Approach / Method."
}
if (-not (Select-String -Path report-1page.md -Pattern 'kết quả|result' -IgnoreCase -Quiet)) {
	Fail "report-1page.md phải có mục Kết quả / Result."
}
if (-not (Select-String -Path report-1page.md -Pattern 'kết luận|conclusion' -IgnoreCase -Quiet)) {
	Fail "report-1page.md phải có mục Kết luận / Conclusion."
}
Pass "report-1page.md có đủ các mục tối thiểu."

# Logs evidence count (exclude .gitkeep and README.md)
$logFiles = Get-ChildItem -Path logs -File | Where-Object { $_.Name -ne '.gitkeep' -and $_.Name -ne 'README.md' }
if (($logFiles | Measure-Object).Count -lt 1) { Fail "Thư mục logs/ phải có ít nhất 1 file minh chứng thật (không tính .gitkeep hoặc README.md)." }
Pass "Có file minh chứng trong logs/."

# Negative tests checks in tests/
if (-not (Select-String -Path tests\* -Pattern 'tamper|flip[ -]?1[ -]?byte|bit flip|sửa 1 byte' -IgnoreCase -Quiet)) {
	Fail "tests/ phải có negative test cho tamper / flip 1 byte."
}
if (-not (Select-String -Path tests\* -Pattern 'wrong key|invalid key|incorrect key|sai key|khóa sai' -IgnoreCase -Quiet)) {
	Fail "tests/ phải có negative test cho wrong key."
}
Pass "Có dấu hiệu negative tests cho tamper và wrong key."

# Check source input usage
$sourceFiles = Get-ChildItem -Path . -Recurse -Include *.cpp,*.h,*.hpp | Where-Object { $_.FullName -notmatch '\.github' -and $_.FullName -notmatch '\\build\\' }
$foundInput = $false
foreach ($f in $sourceFiles) {
	if (Select-String -Path $f.FullName -Pattern 'cin\s*>>|getline\s*\(' -SimpleMatch -Quiet) {
		$foundInput = $true
		break
	}
}
if (-not $foundInput) { Fail "Chưa thấy dấu hiệu nhập từ bàn phím trong source code. Q2 yêu cầu cho phép người dùng nhập plaintext và key." }
Pass "Có dấu hiệu nhập dữ liệu từ bàn phím trong source code."

# Check for TODO_STUDENT placeholders
try {
	$todo = Select-String -Path README.md,report-1page.md,tests\* -Pattern 'TODO_STUDENT' -SimpleMatch -ErrorAction Stop
	if ($todo) { Fail "Vẫn còn placeholder TODO_STUDENT trong README/report/tests. Hãy hoàn thiện trước khi nộp." }
} catch {
	# no matches -> good
}
Pass "Không còn placeholder TODO_STUDENT trong README/report/tests."

# Check for built binary
if (Test-Path './des.exe' -PathType Leaf -or Test-Path './des' -PathType Leaf) { Pass "Đã có file thực thi sau bước build." }

Write-Output "[SUCCESS] Repo đáp ứng bộ kiểm tra nộp bài cơ bản cho FIT4012 Lab 4."
