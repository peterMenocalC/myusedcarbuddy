import 'dart:core';


class InspectionRequestListData {
   int orderId;
   String timeAge;
   String buyer;
   String seller;
   String salesPerson;
   String location;
   String carYear;
   String carMake;
   String carModel;
   int isInspectionAccepted;
   String inspectionAcceptedDate;
   String salesPersonPhone;
   String SellerPhone;
   String vehicleVin;
   String scheduleDate;
   String customerNotes;

   InspectionRequestListData(

   {this.orderId,
      this.timeAge,
      this.buyer,
      this.seller,
      this.salesPerson,
      this.location,
      this.carYear,
       this.carMake,
      this.carModel,
     this.isInspectionAccepted,
     this.inspectionAcceptedDate,
     this.salesPersonPhone,
     this.SellerPhone,
     this.vehicleVin,
     this.scheduleDate,
     this.customerNotes
   });

   InspectionRequestListData.fromJson(Map<String, dynamic> json) {
     orderId = json['order_id'];
     timeAge = json['time_age'];
     buyer = json['buyer'];
     seller = json['seller'];
     salesPerson = json['sales_person'];
     location = json['location'];
     carYear = json['car_year'];
     carMake = json['car_make'];
     carModel = json['car_model'];
     isInspectionAccepted = json['is_inspection_accepted'];
     inspectionAcceptedDate = json['inspection_accepted_date'];
     salesPersonPhone = json['salesperson_phone'];
     SellerPhone = json['seller_phone'];
     vehicleVin = json['vehicle_vin'];
     scheduleDate = json['schedule_date'];
     customerNotes = json['customer_notes'];
   }

   Map<String, dynamic> toJson() {
     final Map<String, dynamic> data = new Map<String, dynamic>();
     data['order_id'] = this.orderId;
     data['time_age'] = this.timeAge;
     data['buyer'] = this.buyer;
     data['seller'] = this.seller;
     data['sales_person'] = this.salesPerson;
     data['location'] = this.location;
     data['car_year'] = this.carYear;
     data['car_make'] = this.carMake;
     data['car_model'] = this.carModel;
     data['is_inspection_accepted'] = this.isInspectionAccepted;
     data['inspection_accepted_date'] = this.inspectionAcceptedDate;
     data['salesperson_phone'] = this.salesPersonPhone;
     data['seller_phone'] = this.SellerPhone;
     data['vehicle_vin'] = this.vehicleVin;
     data['schedule_date'] = this.scheduleDate;
     data['customer_notes'] = this.customerNotes;

     return data;
   }
}