class InspectionDetails {
   String orderId;
   String timeAge;
   String meridiem;
   String packageName;
   int inspectorFee;
   String seller;
   String sellerPhone;
   String additionalDetails;
   String buyer;
   String buyerCompany;
   String buyerAddress;
   String buyerAptSte;
   String buyerCity;
   String buyerState;
   String buyerPostcode;
   String buyerCountry;
   String buyerEmail;
   String buyerPhone;
   String salesPerson;
   String salespersonPhone;
   String vehicleCity;
   String vehicleState;
   String vehicleLocationZip;
   String vehicleIsVatExempt;
   String location;
   String carYear;
   String carMake;
   String carModel;
   String vehicleVin;
   String vehicleTrim;
   int vehicleStockNumber;
   int vehicleMilage;
   String vehicleExteriorColor;
   String vehicleInteriorColor;
   String vehicleInteriorType;
   String vehicleEngineType;
   String vehicleDriveTrain;
   String vehicleRoof;
   String vehicleFrameDamage;
   String vehicleFlood;
   String vehicleCodes;
   String vehicleLeaks;
   String vehicleAcTemp;
   String vehiclePriorRepair;
   String carFax;
   String tireLfBrand;
   String tireLfThread;
   String tireLfWidth;
   String tireLfHeight;
   String tireLfRim;
   String tireRfBrand;
   String tireRfThread;
   String tireRfWidth;
   String tireRfHeight;
   String tireRfRim;
   int tireRrBrand;
   int tireRrTread;
   int tireRrWidth;
   int tireRrHeight;
   int tireRrRim;
   int tireLrBrand;
   int tireLrTread;
   int tireLrWidth;
   int tireLrHeight;
   int tireLrRim;
   int spareBrand;
   int spareTread;
   int spareWidth;
   int spareHeight;
   int spareRim;
   int spareType;
   int spareDamage;
   int airPump;
   int wheelType;
   int wheelDamage;
   int keylessRemotes;
   int keylessRemotesDamaged;
   int ownerBooks;
   int floorMatsWorn;
   int floorMatsDamaged;
   int floorMatsMissing;
   String qboSaleRefId;
   String appointmentDate;
   String downloadedDate;
   String createdDate;
   String modificationDate;
   String assignedDate;
   String scheduleDate;
   String completedDate;
   String releasedDate;

   InspectionDetails(
   {
     this.orderId,
     this.timeAge,
     this.packageName,
     this.inspectorFee,
     this.seller,
     this.sellerPhone,
     this.additionalDetails,
     this.buyer,
     this.buyerCompany,
     this.buyerAddress,
     this.buyerAptSte,
     this.buyerCity,
     this.buyerState,
     this.buyerPostcode,
     this.buyerCountry,
     this.buyerEmail,
     this.buyerPhone,
     this.salesPerson,
     this.salespersonPhone,
     this.vehicleCity,
     this.vehicleState,
     this.vehicleLocationZip,
     this.vehicleIsVatExempt,
     this.location,
     this.carYear,
     this.carMake,
     this.carModel,
     this.vehicleVin,
     this.vehicleTrim,
     this.vehicleStockNumber,
     this.vehicleMilage,
     this.vehicleExteriorColor,
     this.vehicleInteriorColor,
     this.vehicleInteriorType,
     this.vehicleEngineType,
     this.vehicleDriveTrain,
     this.vehicleRoof,
     this.vehicleFrameDamage,
     this.vehicleFlood,
     this.vehicleCodes,
     this.vehicleLeaks,
     this.vehicleAcTemp,
     this.vehiclePriorRepair,
     this.carFax,
     this.tireLfBrand,
     this.tireLfThread,
     this.tireLfWidth,
     this.tireLfHeight,
     this.tireLfRim,
     this.tireRfBrand,
     this.tireRfThread,
     this.tireRfWidth,
     this.tireRfHeight,
     this.tireRfRim,
     this.tireRrBrand,
     this.tireRrTread,
     this.tireRrWidth,
     this.tireRrHeight,
     this.tireRrRim,
     this.tireLrBrand,
     this.tireLrTread,
     this.tireLrWidth,
     this.tireLrHeight,
     this.tireLrRim,
     this.spareBrand,
     this.spareTread,
     this.spareWidth,
     this.spareHeight,
     this.spareRim,
     this.spareType,
     this.spareDamage,
     this.airPump,
     this.wheelType,
     this.wheelDamage,
     this.keylessRemotes,
     this.keylessRemotesDamaged,
     this.ownerBooks,
     this.floorMatsWorn,
     this.floorMatsDamaged,
     this.floorMatsMissing,
     this.qboSaleRefId,
     this.appointmentDate,
     this.downloadedDate,
     this.createdDate,
     this.modificationDate,
     this.assignedDate,
     this.scheduleDate,
     this.completedDate,
     this.releasedDate,
     this.meridiem
}
      );

   InspectionDetails.fromJson(Map<String, dynamic> json) {
     orderId= json['order_id'];
     timeAge= json['time_age'];
     packageName= json['package_name'];
     inspectorFee= json['inspector_fee'];
     seller= json['seller'];
     sellerPhone= json['seller_phone'];
     additionalDetails= json['additional_details'];
     buyer= json['buyer'];
     buyerCompany= json['buyer_company'];
     buyerAddress= json['buyer_address'];
     buyerAptSte= json['buyer_apt_ste'];
     buyerCity= json['buyer_city'];
     buyerState= json['buyer_state'];
     buyerPostcode= json['buyer_postcode'];
     buyerCountry= json['buyer_country'];
     buyerEmail= json['buyer_email'];
     buyerPhone= json['buyer_phone'];
     salesPerson= json['sales_person'];
     salespersonPhone= json['salesperson_phone'];
     vehicleCity= json['vehicle_city'];
     vehicleState= json['vehicle_state'];
     vehicleLocationZip= json['vehicle_location_zip'];
     vehicleIsVatExempt= json['vehicle_is_vat_exempt'];
     location= json['location'];
     carYear= json['car_year'];
     carMake= json['car_make'];
     carModel= json['car_model'];
     vehicleVin= json['vehicle_vin'];
     vehicleTrim= json['vehicle_trim'];
     vehicleStockNumber= json['vehicle_stock_number'];
     vehicleMilage= json['vehicle_milage'];
     vehicleExteriorColor= json['vehicle_exterior_color'];
     vehicleInteriorColor= json['vehicle_interior_color'];
     vehicleInteriorType= json['vehicle_interior_type'];
     vehicleEngineType= json['vehicle_engine_type'];
     vehicleDriveTrain= json['vehicle_drive_train'];
     vehicleRoof= json['vehicle_roof'];
     vehicleFrameDamage= json['vehicle_frame_damage'];
     vehicleFlood= json['vehicle_flood'];
     vehicleCodes= json['vehicle_codes'];
     vehicleLeaks= json['vehicle_leaks'];
     vehicleAcTemp= json['vehicle_ac_temp'];
     vehiclePriorRepair= json['vehicle_prior_repair'];
     carFax= json['car_fax'];
     tireLfBrand= json['tire_lf_brand'];
     tireLfThread= json['tire_lf_thread'];
     tireLfWidth= json['tire_lf_width'];
     tireLfHeight= json['tire_lf_height'];
     tireLfRim= json['tire_lf_rim'];
     tireRfBrand= json['tire_rf_brand'];
     tireRfThread= json['tire_rf_thread'];
     tireRfWidth= json['tire_rf_width'];
     tireRfHeight= json['tire_rf_height'];
     tireRfRim= json['tire_rf_rim'];
     tireRrBrand= json['tire_rr_brand'];
     tireRrTread= json['tire_rr_tread'];
     tireRrWidth= json['tire_rr_width'];
     tireRrHeight= json['tire_rr_height'];
     tireRrRim= json['tire_rr_rim'];
     tireLrBrand= json['tire_lr_brand'];
     tireLrTread= json['tire_lr_tread'];
     tireLrWidth= json['tire_lr_width'];
     tireLrHeight= json['tire_lr_height'];
     tireLrRim= json['tire_lr_rim'];
     spareBrand= json['spare_brand'];
     spareTread= json['spare_tread'];
     spareWidth= json['spare_width'];
     spareHeight= json['spare_height'];
     spareRim= json['spare_rim'];
     spareType= json['spare_type'];
     spareDamage= json['spare_damage'];
     airPump= json['air_pump'];
     wheelType= json['wheel_type'];
     wheelDamage= json['wheel_damage'];
     keylessRemotes= json['keyless_remotes'];
     keylessRemotesDamaged= json['keyless_remotes_damaged'];
     ownerBooks= json['owner_books'];
     floorMatsWorn= json['floor_mats_worn'];
     floorMatsDamaged= json['floor_mats_damaged'];
     floorMatsMissing= json['floor_mats_missing'];
     qboSaleRefId= json['qbo_sale_ref_id'];
     appointmentDate= json['appointment_date'];
     downloadedDate= json['downloaded_date'];
     createdDate= json['created_date'];
     modificationDate= json['modification_date'];
     assignedDate= json['assigned_date'];
     scheduleDate= json['schedule_date'];
     completedDate = json['completed_date'];
     releasedDate =  json['released_date'];
     meridiem = json['meridiem'];
   }

   Map<String, dynamic> toJson() {
     final Map<String, dynamic> data = new Map<String, dynamic>();
      data['order_id'] = this.orderId;
      data['time_age'] = this.timeAge;
      data['package_name'] = this.packageName;
      data['inspector_fee'] = this.inspectorFee;
      data['seller'] = this.seller;
      data['seller_phone'] = this.sellerPhone;
      data['additional_details'] = this.additionalDetails;
      data['buyer'] = this.buyer;
      data['buyer_company'] = this.buyerCompany;
      data['buyer_address'] = this.buyerAddress;
      data['buyer_apt_ste'] = this.buyerAptSte;
      data['buyer_city'] = this.buyerCity;
      data['buyer_state'] = this.buyerState;
      data['buyer_postcode'] = this.buyerPostcode;
      data['buyer_country'] = this.buyerCountry;
      data['buyer_email'] = this.buyerEmail;
      data['buyer_phone'] = this.buyerPhone;
      data['sales_person'] = this.salesPerson;
      data['salesperson_phone'] = this.salespersonPhone;
      data['vehicle_city'] = this.vehicleCity;
      data['vehicle_state'] = this.vehicleState;
      data['vehicle_location_zip'] = this.vehicleLocationZip;
     data['vehicle_is_vat_exempt'] = this.vehicleIsVatExempt;
     data['location'] = this.location;
     data['car_year'] = this.carYear;
     data['car_make'] = this.carMake;
     data['car_model'] = this.carModel;
     data['vehicle_vin'] = this.vehicleVin;
     data['vehicle_trim'] = this.vehicleTrim;
     data['vehicle_stock_number'] = this.vehicleStockNumber;
     data['vehicle_milage'] = this.vehicleMilage;
     data['vehicle_exterior_color'] = this.vehicleExteriorColor;
     data['vehicle_interior_color'] = this.vehicleInteriorColor;
     data['vehicle_interior_type'] = this.vehicleInteriorType;
     data['vehicle_engine_type'] = this.vehicleEngineType;
     data['vehicle_drive_train'] = this.vehicleDriveTrain;
     data['vehicle_roof'] = this.vehicleRoof;
     data['vehicle_frame_damage'] = this.vehicleFrameDamage;
     data['vehicle_flood'] = this.vehicleFlood;
     data['vehicle_codes'] = this.vehicleCodes;
     data['vehicle_leaks'] = this.vehicleLeaks;
     data['vehicle_ac_temp'] = this.vehicleAcTemp;
     data['vehicle_prior_repair'] = this.vehiclePriorRepair;
     data['car_fax'] = this.carFax;
     data['tire_lf_brand'] = this.tireLfBrand;
     data['tire_lf_thread'] = this.tireLfThread;
     data['tire_lf_width'] = this.tireLfWidth;
     data['tire_lf_height'] = this.tireLfHeight;
     data['tire_lf_rim'] = this.tireLfRim;
     data['tire_rf_brand'] = this.tireRfBrand;
     data['tire_rf_thread'] = this.tireRfThread;
     data['tire_rf_width'] = this.tireRfWidth;
     data['tire_rf_height'] = this.tireRfHeight;
     data['tire_rf_rim'] = this.tireRfRim;
     data['tire_rr_brand'] = this.tireRrBrand;
     data['tire_rr_tread'] = this.tireRrTread;
     data['tire_rr_width'] = this.tireRrWidth;
     data['tire_rr_height'] = this.tireRrHeight;
     data['tire_rr_rim'] = this.tireRrRim;
     data['tire_lr_brand'] = this.tireLrBrand;
     data['tire_lr_tread'] = this.tireLrTread;
     data['tire_lr_width'] = this.tireLrWidth;
     data['tire_lr_height'] = this.tireLrHeight;
     data['tire_lr_rim'] = this.tireLrRim;
     data['spare_brand'] = this.spareBrand;
     data['spare_tread'] = this.spareTread;
     data['spare_width'] = this.spareWidth;
     data['spare_height'] = this.spareHeight;
     data['spare_rim'] = this.spareRim;
     data['spare_type'] = this.spareType;
     data['spare_damage'] = this.spareDamage;
     data['air_pump'] = this.airPump;
     data['wheel_type'] = this.wheelType;
     data['wheel_damage'] = this.wheelDamage;
     data['keyless_remotes'] = this.keylessRemotes;
     data['keyless_remotes_damaged'] = this.keylessRemotesDamaged;
     data['owner_books'] = this.ownerBooks;
     data['floor_mats_worn'] = this.floorMatsWorn;
     data['floor_mats_damaged'] = this.floorMatsDamaged;
     data['floor_mats_missing'] = this.floorMatsMissing;
     data['qbo_sale_ref_id'] = this.qboSaleRefId;
     data['appointment_date'] = this.appointmentDate;
     data['downloaded_date'] = this.downloadedDate;
     data['created_date'] = this.createdDate;
     data['modification_date'] = this.modificationDate;
     data['assigned_date'] = this.assignedDate;
     data['schedule_date'] = this.scheduleDate;
      data['completed_date'] = this.completedDate;
      data['released_date'] = this.releasedDate;
      data['meridiem'] = this.meridiem;
     return data;
   }
}