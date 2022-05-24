package com.ventechsolutions.myFHB.bloodpressure.model.entity;

import androidx.annotation.Nullable;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.List;
import java.util.Map;

import jp.co.ohq.ble.enumerate.OHQCompletionReason;
import jp.co.ohq.ble.enumerate.OHQDeviceCategory;
import jp.co.ohq.ble.enumerate.OHQMeasurementRecordKey;
import jp.co.ohq.ble.enumerate.OHQSessionOptionKey;
import jp.co.ohq.ble.enumerate.OHQUserDataKey;

public class SessionData {
    @Nullable
    private Map<OHQSessionOptionKey, Object> option;
    @Nullable
    private OHQDeviceCategory deviceCategory;
    @Nullable
    private String deviceAddress;
    @Nullable
    private String currentTime;
    @Nullable
    private Integer batteryLevel;
    @Nullable
    private Integer userIndex;
    @Nullable
    private Map<OHQUserDataKey, Object> userData;
    @Nullable
    private Long databaseChangeIncrement;
    @Nullable
    private Integer sequenceNumberOfLatestRecord;
    @Nullable
    private List<Map<OHQMeasurementRecordKey, Object>> measurementRecords;
    @Nullable
    private OHQCompletionReason completionReason;
    @Nullable
    private String modelName;

    @Nullable
    public Map<OHQSessionOptionKey, Object> getOption() {
        return option;
    }

    public void setOption(@Nullable Map<OHQSessionOptionKey, Object> option) {
        this.option = option;
    }

    @Nullable
    public OHQDeviceCategory getDeviceCategory() {
        return deviceCategory;
    }

    public void setDeviceCategory(@Nullable OHQDeviceCategory deviceCategory) {
        this.deviceCategory = deviceCategory;
    }

    @Nullable
    public String getModelName() {
        return modelName;
    }

    public void setModelName(@Nullable String modelName) {
        this.modelName = modelName;
    }

    @Nullable
    public String getCurrentTime() {
        return currentTime;
    }

    public void setCurrentTime(@Nullable String currentTime) {
        this.currentTime = currentTime;
    }

    @Nullable
    public Integer getBatteryLevel() {
        return batteryLevel;
    }

    public void setBatteryLevel(@Nullable Integer batteryLevel) {
        this.batteryLevel = batteryLevel;
    }

    @Nullable
    public Integer getUserIndex() {
        return userIndex;
    }

    public void setUserIndex(@Nullable Integer userIndex) {
        this.userIndex = userIndex;
    }

    @Nullable
    public Map<OHQUserDataKey, Object> getUserData() {
        return userData;
    }

    public void setUserData(@Nullable Map<OHQUserDataKey, Object> userData) {
        this.userData = userData;
    }

    @Nullable
    public Long getDatabaseChangeIncrement() {
        return databaseChangeIncrement;
    }

    public void setDatabaseChangeIncrement(@Nullable Long databaseChangeIncrement) {
        this.databaseChangeIncrement = databaseChangeIncrement;
    }

    @Nullable
    public Integer getSequenceNumberOfLatestRecord() {
        return sequenceNumberOfLatestRecord;
    }

    public void setSequenceNumberOfLatestRecord(@Nullable Integer sequenceNumberOfLatestRecord) {
        this.sequenceNumberOfLatestRecord = sequenceNumberOfLatestRecord;
    }

    @Nullable
    public List<Map<OHQMeasurementRecordKey, Object>> getMeasurementRecords() {
        return measurementRecords;
    }

    public void setMeasurementRecords(@Nullable List<Map<OHQMeasurementRecordKey, Object>> measurementRecords) {
        this.measurementRecords = measurementRecords;
    }

    @Nullable
    public OHQCompletionReason getCompletionReason() {
        return completionReason;
    }

    public void setCompletionReason(@Nullable OHQCompletionReason completionReason) {
        this.completionReason = completionReason;
    }
    @Nullable
    public String getDeviceAddress() {
        return deviceAddress;
    }

    public void setDeviceAddress(@Nullable String deviceAddress) {
        this.deviceAddress = deviceAddress;
    }

    @Override
    public String toString() {

        JSONObject jsonObject = new JSONObject();

        JSONArray arr = new JSONArray();
        if (measurementRecords != null) {
            try {
                for (Map<OHQMeasurementRecordKey, Object> map : measurementRecords) {
                    JSONObject json_obj = new JSONObject();
                    for (Map.Entry<OHQMeasurementRecordKey, Object> entry : map.entrySet()) {
                        OHQMeasurementRecordKey key = entry.getKey();
                        Object value = entry.getValue();
                        try {
                            json_obj.put(String.valueOf(key), value);
                        } catch (JSONException e) {
                            // TODO Auto-generated catch block
                            e.printStackTrace();
                        }
                    }
                    arr.put(json_obj);
                }

                jsonObject.put("option", option);
                jsonObject.put("deviceCategory", deviceCategory);
                jsonObject.put("modelName", modelName);
                jsonObject.put("deviceAddress", deviceAddress);
                jsonObject.put("currentTime", currentTime);
                jsonObject.put("batteryLevel", batteryLevel);
                jsonObject.put("userIndex", userIndex);
                jsonObject.put("userData", userData);
                jsonObject.put("databaseChangeIncrement", databaseChangeIncrement);
                jsonObject.put("sequenceNumberOfLatestRecord", sequenceNumberOfLatestRecord);
                jsonObject.put("measurementRecords", arr);
                jsonObject.put("completionReason", completionReason);

                return jsonObject.toString();
            } catch (JSONException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
                return "";
            }
        } else {
            return "";

        }


        /*return "SessionData{" +
                "option=" + option +
                ", deviceCategory=" + deviceCategory +
                ", modelName='" + modelName + '\'' +
                ", currentTime='" + currentTime + '\'' +
                ", batteryLevel=" + batteryLevel +
                ", userIndex=" + userIndex +
                ", userData=" + userData +
                ", databaseChangeIncrement=" + databaseChangeIncrement +
                ", sequenceNumberOfLatestRecord=" + sequenceNumberOfLatestRecord +
                ", measurementRecords=" + measurementRecords +
                ", completionReason=" + completionReason +
                '}';*/
    }

    /*public String toJSON(){

        JSONObject jsonObject= new JSONObject();
        JSONObject measureObject= new JSONObject();
        JSONArray arr = new JSONArray();
        try {
            jsonObject.put("option", option);
            jsonObject.put("deviceCategory", deviceCategory);
            jsonObject.put("modelName", modelName);
            jsonObject.put("currentTime", currentTime);
            jsonObject.put("batteryLevel", batteryLevel);
            jsonObject.put("userIndex", userIndex);
            jsonObject.put("userData", userData);
            jsonObject.put("databaseChangeIncrement", databaseChangeIncrement);
            jsonObject.put("sequenceNumberOfLatestRecord", sequenceNumberOfLatestRecord);

            arr.put(measurementRecords);
            for (int i = 0; i < arr.length(); i++) {
                measureObject.put("DiastolicKey",measurementRecords);
                measureObject.put("PulseRateKey");
                measureObject.put("UserIndexKey");
                measureObject.put("MeanArterialPressureKey");
                measureObject.put("SystolicKey");
                measureObject.put("BloodPressureUnitKey");
                measureObject.put("TimeStampKey");
                measureObject.put("BloodPressureMeasurementStatusKey");
                measureObject.put("completionReason");
            }


            jsonObject.put("measurementRecords", arr);
            jsonObject.put("completionReason", completionReason);

            return jsonObject.toString();
        } catch (JSONException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
            return "";
        }

    }*/
}
