module Language
  extend ActiveSupport::Concern

  private
  def set_language(str)
    case I18n.locale
    when :vi
      str = str.gsub(/[aeiouyd]/, 'a' => '[aàáạảãâầấậẩẫăằắặẳẵ]', 'e' => '[eèéẹẻẽêềếệểễ]', 'i' => '[iìíịỉĩ]', 'o' => '[oòóọỏõôồốộổỗơờớợởỡ]', 'u' => '[uùúụủũưừứựửữ]', 'y' => '[yỳýỵỷỹ]', 'd' => '[dđ]')
    end
    return str
  end

end