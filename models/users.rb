def logged_in?
    return !!current_user
end

def current_user
    return get_user(session[:user_id].to_i)
end

def logout_user
    session[:user_id] = nil
end

def create_user first_name, last_name, email, password, birth_year
    hashed_password = BCrypt::Password.create(password)
    exec_sql("INSERT INTO users (first_name, last_name, email, hashed_password, birth_year) VALUES ($1, $2, $3, $4, $5);",[first_name,last_name,email,hashed_password, birth_year])
    return exec_sql("SELECT user_id FROM users WHERE email = $1;",[email]).first
end

def get_user search_value
    if search_value.class == Integer
        return exec_sql("SELECT * FROM users WHERE user_id = $1;", [search_value]).first
    else
        return exec_sql("SELECT * FROM users WHERE email = $1;",[search_value]).first
    end
end

def delete_user user_id
    exec_sql("DELETE FROM exercise_sets WHERE user_id = $1;",[user_id])
    exec_sql("DELETE FROM users WHERE user_id = $1;",[user_id])
end