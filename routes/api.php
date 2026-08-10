<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

Route::post('/tes-upload', function (Request $request) {
    return response()->json([
        'message' => 'Upload berhasil diterima!',
        'nama_barang' => $request->input('nama'),
        'file_diterima' => $request->hasFile('foto') ? $request->file('foto')->getClientOriginalName() : 'Gak ada file',
    ]);
});

Route::get('/tes-glitchtip', function () {
    throw new Exception('Aplikasi meledak, tes GlitchTip!');
});
