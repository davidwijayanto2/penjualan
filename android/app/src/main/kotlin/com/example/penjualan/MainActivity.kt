package com.example.penjualan

import android.os.Environment
import android.util.Log
import android.widget.Toast

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream
import java.io.IOException
import java.nio.channels.FileChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "database"
    private var BUFFERSZ:Int = 32768
    private var buffer= byteArrayOf(BUFFERSZ.toByte())
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
        call, result ->
        val sd = Environment.getExternalStorageDirectory().toString()
        val data = Environment.getDataDirectory()
        var source:FileChannel
        var destination: FileChannel
        val currentDBPath: String = "/user/0/com.example.penjualan/app_flutter/db_ko_stefan"
        val backupDBPath  = "/db_ko_stefan.sqlite3"
        var backupDB:File
        var dir = File(sd);
        if(dir.exists()){
            backupDB = File(sd,backupDBPath)
            Log.v("message", "masuk")
        } else {        
            val f = File(sd)
            f.mkdir()
            backupDB = File(sd,backupDBPath)
            Log.v("message", "keluar")
        }
        val myDB = File(data, currentDBPath)      
        if (call.method == "backupdatabase"){
            // if(checkrequestpermission()) {
                
            // } else {
            //     requestpermission()
            // }        
            source = FileInputStream(myDB).getChannel()
            destination = FileOutputStream(backupDB).getChannel()
            try {
            
            destination.transferFrom(source, 0, source.size())
            // source.close()
            // destination.close()
            //Toast.makeText(this, "Database berhasil dibackup!", Toast.LENGTH_LONG).show()
            result.success("Database berhasil dibackup!");
            } catch(e: IOException) {
            //Toast.makeText(this, "Backup database gagal!", Toast.LENGTH_LONG).show()
            result.error("FAILED", "Backup database gagal!", null);
            e.printStackTrace()
            }finally{
            try {
                if(source != null){
                source.close()
                }
            } finally {
                if(destination != null){
                destination.close()
                }
            }
            }
        } else if(call.method == "restoredatabase"){
            if (backupDB.exists()) {
            source = FileOutputStream(myDB).getChannel()
            destination = FileInputStream(backupDB).getChannel()
            try {            
                destination.transferTo(0, destination.size(),source)
                // source.close()
                // destination.close()
                //Toast.makeText(this, "Database berhasil direstore!", Toast.LENGTH_LONG).show()
                result.success("Database berhasil direstore!");
            } catch(e: IOException) {
                //Toast.makeText(this, "Restore database gagal!", Toast.LENGTH_LONG).show()
                result.error("FAILED", "Restore database gagal!", null);
                e.printStackTrace()
            }  finally{
                try {
                if(source != null){
                    source.close()
                }
                } finally {
                if(destination != null){
                    destination.close()
                }
                }
            } 
                // Access the copied database so SQLiteHelper will cache it and mark
                // it as created.
            
            }else {
            //Toast.makeText(this, "File backup tidak ditemukan!", Toast.LENGTH_LONG).show()
            result.error("UNAVAILABLE", "File backup tidak ditemukan!", null);
            }          
        } else {
            result.notImplemented()
        }
    }
  }
}
