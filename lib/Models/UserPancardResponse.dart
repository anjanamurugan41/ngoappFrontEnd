class UserPancardResponse {
    int statusCode;
    UserDetails userDetails;

    UserPancardResponse({this.statusCode, this.userDetails});

    factory UserPancardResponse.fromJson(Map<String, dynamic> json) {
        return UserPancardResponse(
            statusCode: json['statusCode'],
            userDetails: json['userDetails'] != null ? UserDetails.fromJson(json['userDetails']) : null,
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['statusCode'] = this.statusCode;
        if (this.userDetails != null) {
            data['userDetails'] = this.userDetails.toJson();
        }
        return data;
    }
}

class UserDetails {
    Object auth_key;
    Object country_code;
    String created_at;
    String customer_id;
    Object date_of_birth;
    String email;
    int id;
    String baseUrl;
    String image_url;
    String modified_at;
    String name;
    Object pancard_image;
    String password_hash;
    Object phone_number;
    int points;
    String role;
    int status;
    String username;
    String virtual_account_id;

    UserDetails({this.auth_key, this.country_code, this.created_at, this.customer_id, this.date_of_birth, this.email, this.id, this.image_url, this.modified_at, this.name, this.pancard_image, this.password_hash, this.phone_number, this.points, this.role, this.status, this.username, this.virtual_account_id, this.baseUrl});

    factory UserDetails.fromJson(Map<String, dynamic> json) {
        return UserDetails(
            auth_key: json['auth_key'] != null ,
            country_code: json['country_code'] != null ,
            created_at: json['created_at'],
            customer_id: json['customer_id'],
            date_of_birth: json['date_of_birth'] != null,
            email: json['email'],
            id: json['id'],
            baseUrl:json['baseUrl'],
            image_url: json['image_url'],
            modified_at: json['modified_at'],
            name: json['name'],
            pancard_image: json['pancard_image'] ,
            password_hash: json['password_hash'],
            phone_number: json['phone_number'] ,
            points: json['points'],
            role: json['role'],
            status: json['status'],
            username: json['username'],
            virtual_account_id: json['virtual_account_id'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['created_at'] = this.created_at;
        data['customer_id'] = this.customer_id;
        data['email'] = this.email;
        data['id'] = this.id;
        data['base_url']=this.baseUrl;
        data['image_url'] = this.image_url;
        data['modified_at'] = this.modified_at;
        data['name'] = this.name;
        data['password_hash'] = this.password_hash;
        data['points'] = this.points;
        data['role'] = this.role;
        data['status'] = this.status;
        data['username'] = this.username;
        data['virtual_account_id'] = this.virtual_account_id;
        data['auth_key'] = this.auth_key;
        data['country_code'] = this.country_code;
        data['date_of_birth'] = this.date_of_birth;
        data['pancard_image'] = this.pancard_image;
        data['phone_number'] = this.phone_number;
        return data;
    }
}